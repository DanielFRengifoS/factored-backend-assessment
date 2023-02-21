class UsersController < ApplicationController

  def post
    @user = User.new(user_params)
    @user.password = BCrypt::Password.create(user_params[:password])
    if @user.save
      render json: { message: 'User created successfully.' }, status: :created
    else
      render json: { error: @user.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  def validate 
    @user = User.find_by(email: params[:user][:email])
    if @user && BCrypt::Password.new(@user.password) == params[:user][:password]
      render json: { message: 'User authenticated successfully.' }, status: :ok
    else
      render json: { error: 'Invalid email or password.' }, status: :unauthorized
    end
  end

  def get
    email = CGI.unescape(params[:email])
    @user = User.find_by(email: email)
    if @user
      render json: { email: @user.email }, status: :ok
    else
      render json: { error: 'Error retrieving user' }, status: :error
    end
  end

  def delete
    @user = User.find_by(email: params[:user][:email])
    if @user
      @user.destroy
      render json: { message: 'User deleted successfully.' }, status: :ok
    else
      render json: { error: 'User not found.' }, status: :not_found
    end
  end

  def update
    @user = User.find_by(email: params[:email])
    if @user
      @user.email = params[:new_email]
      if @user.save
        render json: { message: 'User updated successfully.' }, status: :ok
      else
        render json: { error: @user.errors.full_messages.join(', ') }, status: :unprocessable_entity
      end
    else
      render json: { error: 'User not found.' }, status: :not_found
    end
  end
  
  private

  def user_params
    params.require(:user).permit(:email, :password)
  end
end

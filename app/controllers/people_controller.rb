class PeopleController < ApplicationController
  def index
    query_params = params.permit(
      :name, :height, :mass, :hair_color,
      :skin_color, :eye_color, :birth_year, :gender,
      :homeworld, :film
    )
  
    @people = Person.includes(:films, :homeworld)
  
    if query_params.present?
      query_params.transform_values! do |value|
        value.present? ? "%#{value.downcase}%" : value
      end
  
      conditions = []
      conditions_params = []
    
      query_params.each do |key, value|
        next unless value.present?
    
        case key.to_sym
        when :homeworld
          conditions << 'lower(planets.name) LIKE ?'
          conditions_params << value
          @people = @people.joins(:homeworld).joins('JOIN planets ON planets.id = people.planet_id')
        when :film
          conditions << "lower(films.title) LIKE ?"
          conditions_params << value
          @people = @people.joins(:films).joins('JOIN films_people ON films_people.person_id = people.id').joins('JOIN films ON films.id = films_people.film_id')
        else
          conditions << "lower(#{key}) LIKE ?"
          conditions_params << value
        end
      end
  
      @people = @people.where(conditions.join(' AND '), *conditions_params)
    end
  
    page = params.fetch(:page, 1).to_i
    per_page = params.fetch(:pageCount, 20).to_i
    offset = (page - 1) * per_page
    @people = @people.offset(offset).limit(per_page)
  
    render json: @people, include: :films
  end
  
    
    def get
        @person = Person.includes(:films).find(params[:id])
        render json: @person, include: [:films]
    end

    def post
      @person = Person.new(person_params)
      if @person.save
        render json: @person, status: :created
      else
        render json: @person.errors, status: :unprocessable_entity
      end
    end

    def delete
      @person = Person.find_by(id: params[:id])
    
      if @person
        @person.destroy
        head :no_content
      else
        render json: { error: 'Person not found' }, status: :not_found
      end
    end

    def update
      @person = Person.find_by(id: params[:id])
    
      if @person
        if @person.update(person_params)
          render json: @person
        else
          render json: { errors: @person.errors.full_messages }, status: :unprocessable_entity
        end
      else
        render json: { error: 'Person not found' }, status: :not_found
      end
    end
    
    private
    
    def person_params
      params.require(:person).permit(:name, :birth_year, :eye_color, :hair_color, :height, :mass, :gender, :skin_color, :planet_id)
    end
    
end

class PlanetsController < ApplicationController
    def index
        query_params = params.permit(
          :name, :climate, :terrain, :gravity,
          :rotation_period, :orbital_period, :diameter, :surface_water, :population,
          :film
        )
        @planets = Planet.includes(:films)
      
        if query_params.present?
          query_params.transform_values! do |value|
            value.present? ? "%#{value.downcase}%" : value
          end
      
          conditions = []
          conditions_params = []
      
          query_params.each do |key, value|
            if value.present?
                case key.to_sym
                when :film
                    conditions << "lower(films.title) LIKE ?"
                    conditions_params << value
                    @planets = @planets.joins(:films).joins('JOIN films_planets ON films_planets.planet_id = planets.id').joins('JOIN films ON films.id = films_planets.film_id')
                else
                    conditions << "lower(#{key}) LIKE ?"
                    conditions_params << value
                end
            end
          end
      
          @planets = @planets.where(conditions.join(' AND '), *conditions_params)
        end
        
        page = params.fetch(:page, 1).to_i
        per_page = params.fetch(:pageCount, 20).to_i
        offset = (page - 1) * per_page
        total_count = @planets.count
        @planets = @planets.offset(offset).limit(per_page)
        total_pages = (total_count / per_page.to_f).ceil
        
        render json: { planets: @planets, total_pages: total_pages }, include: :films
    end
      
    def get
        @planet = Planet.includes(:films).find(params[:id])
        render json: @planet, include: [:films]
    end
    
    def post
      @planet = Planet.new(planet_params)
    
      if @planet.save
        render json: @planet, status: :created
      else
        render json: @planet.errors, status: :unprocessable_entity
      end
    end

    def delete
      @planet = Planet.find_by(id: params[:id])
    
      if @planet
        @planet.destroy
        head :no_content
      else
        render json: { error: 'Planet not found' }, status: :not_found
      end
    end

    def update
      @planet = Planet.find_by(id: params[:id])
    
      if @planet
        if @planet.update(planet_params)
          render json: @planet
        else
          render json: { errors: @planet.errors.full_messages }, status: :unprocessable_entity
        end
      else
        render json: { error: 'Planet not found' }, status: :not_found
      end
    end
    
  private
  
  def planet_params
    params.require(:planet).permit(:name, :diameter, :rotation_period, :orbital_period, :gravity, :population, :climate, :terrain, :surface_water)
  end
  
end

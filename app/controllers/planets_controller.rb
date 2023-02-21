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
      
        render json: @planets, include: :films
    end
      
    def get
        @planet = Planet.includes(:films).find(params[:id])
        render json: @planet, include: [:films]
    end
end

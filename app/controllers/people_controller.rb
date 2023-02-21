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
      
        render json: @people, include: :films
      end
    
    def get
        @person = Person.includes(:films).find(params[:id])
        render json: @person, include: [:films]
    end
end

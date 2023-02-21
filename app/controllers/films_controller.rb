class FilmsController < ApplicationController
    def index
        query_params = params.permit(:title, :episode_id, :opening_crawl, :director, :producer, :release_date, :planet, :person)
        @films = Film.includes(:planets, :people)
      
        if query_params.present?
          query_params.transform_values! do |value|
            value.present? ? "%#{value.downcase}%" : value
          end
      
          conditions = []
          conditions_params = []
      
          query_params.each do |key, value|
            next unless value.present?
            case key.to_sym
            when :person
              conditions << "lower(people.name) LIKE ?"
              conditions_params << value
              @films = @films.joins(films_people: :person)
            when :planet
              conditions << "lower(planets.name) LIKE ?"
              conditions_params << value
              @films = @films.joins(films_planets: :planet)
            else
              conditions << "lower(films.#{key}) LIKE ?"
              conditions_params << value
            end
          end
      
          @films = @films.where(conditions.join(' AND '), *conditions_params)
        end
        render json: @films, include: [:planets, :people]
    end

    def get
        @film = Film.includes(:planets, :people).find(params[:id])
        render json: @film, include: [:planets, :people]
    end 
end

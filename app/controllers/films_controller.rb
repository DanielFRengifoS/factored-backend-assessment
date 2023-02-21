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
        page = params.fetch(:page, 1).to_i
        per_page = params.fetch(:pageCount, 20).to_i
        offset = (page - 1) * per_page
        @films = @films.offset(offset).limit(per_page)
        render json: @films, include: [:planets, :people]
    end

    def get
        @film = Film.includes(:planets, :people).find(params[:id])
        render json: @film, include: [:planets, :people]
    end 

    def post
      film = Film.new(film_params)
      if film.save
        # Create FilmsPlanet records for each associated planet
        planet_ids = params[:planet_ids]
        if planet_ids.present?
          planets = Planet.where(id: planet_ids)
          planets.each do |planet|
            FilmsPlanet.create(film: film, planet: planet)
          end
        end
    
        # Create FilmsPerson records for each associated person
        person_ids = params[:person_ids]
        if person_ids.present?
          people = Person.where(id: person_ids)
          people.each do |person|
            FilmsPerson.create(film: film, person: person)
          end
        end
    
        render json: film, status: :created
      else
        render json: { errors: film.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def delete
      @film = Film.find_by(id: params[:id])
    
      if @film
        @film.destroy
        head :no_content
      else
        render json: { error: 'Film not found' }, status: :not_found
      end
    end

    def update
      @film = Film.find_by(id: params[:id])
      if @film
        ActiveRecord::Base.transaction do
          if @film.update(film_params)
            unless params[:planet_ids].nil?
              existing_planet_ids = @film.planet_ids
              new_planet_ids = params[:planet_ids].map { |planet_id| planet_id.to_i }
              planets_to_add = new_planet_ids - existing_planet_ids
              planets_to_remove = existing_planet_ids - new_planet_ids
    
              planets_to_add.each do |planet_id|
                FilmsPlanet.create(film_id: @film.id, planet_id: planet_id)
              end
    
              planets_to_remove.each do |planet_id|
                FilmsPlanet.find_by(film_id: @film.id, planet_id: planet_id)&.destroy
              end
            end
    
            unless params[:person_ids].nil?
              existing_person_ids = @film.person_ids
              new_person_ids = params[:person_ids].map { |person_id| person_id.to_i }
              people_to_add = new_person_ids - existing_person_ids
              people_to_remove = existing_person_ids - new_person_ids
    
              people_to_add.each do |person_id|
                FilmsPerson.create(film_id: @film.id, person_id: person_id)
              end
    
              people_to_remove.each do |person_id|
                FilmsPerson.find_by(film_id: @film.id, person_id: person_id)&.destroy
              end
            end
    
            render json: @film
          else
            render json: { errors: @film.errors.full_messages }, status: :unprocessable_entity
          end
        end
      else
        render json: { error: 'Film not found' }, status: :not_found
      end
    end
    
    private
  
    def film_params
      params.require(:film).permit(:title, :episode_id, :opening_crawl, :director, :producer, :release_date)
    end
    
end

class Planet < ApplicationRecord
    has_many :films_planets
    has_many :films, through: :films_planets, class_name: 'FilmsPlanet'
  
    validates :name, presence: true
    validates :diameter, presence: true
    validates :rotation_period, presence: true
    validates :orbital_period, presence: true
    validates :gravity, presence: true
    validates :population, presence: true
    validates :climate, presence: true
    validates :terrain, presence: true
    validates :surface_water, presence: true
end

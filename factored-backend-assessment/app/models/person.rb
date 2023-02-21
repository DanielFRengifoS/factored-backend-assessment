class Person < ApplicationRecord
    has_many :films_people
    has_many :films, through: :films_people, class_name: 'FilmsPerson'

    belongs_to :homeworld, class_name: 'Planet', foreign_key: 'planet_id'
  
    validates :name, presence: true
    validates :birth_year, presence: true
    validates :eye_color, presence: true
    validates :hair_color, presence: true
    validates :height, presence: true
    validates :mass, presence: true
    validates :gender, presence: true
    validates :skin_color, presence: true
    validates :created, presence: true
    validates :edited, presence: true
end

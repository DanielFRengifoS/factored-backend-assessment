class Film < ApplicationRecord
    has_many :films_planets
    has_many :planets, through: :films_planets, class_name: 'FilmsPlanet'

    has_many :films_people
    has_many :people, through: :films_people, class_name: 'FilmsPerson'
  
    validates :title, presence: true
    validates :episode_id, presence: true
    validates :opening_crawl, presence: true
    validates :director, presence: true
    validates :producer, presence: true
    validates :release_date, presence: true
    validates :created, presence: true
    validates :edited, presence: true
  end
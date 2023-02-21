class FilmsPerson < ApplicationRecord
    belongs_to :film
    belongs_to :person
end

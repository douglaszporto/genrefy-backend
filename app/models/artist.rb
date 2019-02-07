class Artist < ApplicationRecord
    has_many :images
    has_and_belongs_to_many :genres
    has_and_belongs_to_many :users
end

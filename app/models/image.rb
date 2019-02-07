class Image < ApplicationRecord
    belongs_to :artists, optional: true
end

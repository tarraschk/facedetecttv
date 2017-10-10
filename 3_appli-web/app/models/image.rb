class Image < ApplicationRecord
  belongs_to :video
  has_many :portraits
end

class Chaine < ApplicationRecord
  has_many :videos
  belongs_to :stream

end

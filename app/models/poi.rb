class Poi < ActiveRecord::Base
  belongs_to :trip
  # attr_accessible :address, :latitude, :longitude
  geocoded_by :address
  after_validation :geocode
  
end

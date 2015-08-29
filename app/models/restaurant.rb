class Restaurant < ActiveRecord::Base
  belongs_to :trip
  geocoded_by :address
  after_validation :geocode
  
end

class Trip < ActiveRecord::Base
  has_many :pois #use @trip.pois to retrive pois
  validates :place, presence: true

end

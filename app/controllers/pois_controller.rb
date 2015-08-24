class PoisController < ApplicationController
  
  def index
    @pois = Poi.all
  end
  
  def create
    puts "in poi create"
    @trip = Trip.find(params[:trip_id])
    @poi = @trip.pois.create(poi_params)
    # redirect_to trip_path(@trip)
  end
  
  
  def destroy
    @trip = Trip.find(params[:trip_id])
    @poi = @trip.pois.find(params[:id])
    @poi.destroy
    redirect_to trip_path(@trip)
  end
  
 def select
    params[:pois_checkbox].each do |check|
       poi_id = check
       poi = Poi.find_by_id(poi_id)
       #code to update the status here
       poi.update_attribute(:selected, true)
     end
    redirect_to trips_path
 end
 
  def deselect
    params[:pois_checkbox].each do |check|
       poi_id = check
       poi = Poi.find_by_id(poi_id)
       #code to update the status here
       poi.update_attribute(:selected, false)
     end
    redirect_to trips_path
 end
  
  private
    def poi_params
      params.require(:poi).permit(:name)
    end
  
end

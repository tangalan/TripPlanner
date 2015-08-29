class RestaurantsController < ApplicationController
  
   def index
    @restaurants = Restaurant.all
  end
  
  def create
    puts "in restaurant create"
    @trip = Trip.find(params[:trip_id])
    @restaurant = @trip.restaurants.create(restaurant_params)
    # redirect_to trip_path(@trip)
  end
  
  
  def destroy
    @trip = Trip.find(params[:trip_id])
    @restaurant = @trip.restaurants.find(params[:id])
    @restaurant.destroy
    redirect_to trip_path(@trip)
  end
  
 def select
    params[:restaurants_checkbox].each do |check|
       restaurant_id = check
       restaurant = Restaurant.find_by_id(restaurant_id)
       #code to update the status here
       restaurant.update_attribute(:selected, true)
     end
    redirect_to trips_path
 end
 
  def deselect
    params[:restaurants_checkbox].each do |check|
       restaurant_id = check
       restaurant = Restaurant.find_by_id(restaurant_id)
       #code to update the status here
       restaurant.update_attribute(:selected, false)
     end
    redirect_to trips_path
 end
  
  private
    def restaurant_params
      params.require(:restaurant).permit(:name)
    end
  
end

class TripsController < ApplicationController
  
  # before_action :set_trip, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!,  except: [:index]
  
  def index
    @trips = Trip.all
  end
  
  def show
    @trip = Trip.find(params[:id])
  end
  
  def new
    @trip = current_user.trips.build
  end
  
  def edit
    @trip = Trip.find(params[:id])
  end
  
  def create    
    @trip = current_user.trips.build(trip_params) #referring to \models\trip.rb
 
    if @trip.save
      redirect_to @trip # redirects to show action 
    else
      render 'new'
    end 
  end
  
  def update
    @trip = Trip.find(params[:id])
   
    if @trip.update(trip_params)
      redirect_to @trip
    else
      render 'edit'
    end
  end
  
  def destroy
    @trip = Trip.find(params[:id])
    @trip.destroy
   
    redirect_to trips_path
  end
  
  
  private
  def set_task
      @trip = Trip.find(params[:id])
    end
    
  def trip_params
    params.require(:trip).permit(:place)
  end
  
end

module ApplicationHelper 
  
  Point_Of_Interest = Struct.new :name, :address
    
  def get_foursquare_client_id
    foursquare_client_id = "0UHJK0DMCGPKCWTJPPJR4D4YSNWZDPFMBDYJECJTAOBL4YSW"
  end
  
  def get_foursquare_client_secret
    foursquare_client_secret = "OX3JOCNNEE3Q1P5YRE2HHDHYL0MCUJ10JUFQCGNH3ICVHPCT"
  end
  
  def get_foursquare_url 
    client_url = "http://www.tripplanner.com"
  end
  
  def get_flickr_key
    flickr_key = "6d1b744300bc901207531fb49bc7089a"
  end
  
  def get_flickr_secret 
    flickr_secret = "3d4a651a3c2f78b8"
  end
  
  def find_pois
   $poi_array = Array.new
   client = Foursquare2::Client.new(:client_id => get_foursquare_client_id, :client_secret => get_foursquare_client_secret)
   @venues = client.search_venues_by_tip(:near => @trip.place, :query => 'attractions', :v => 20150821) 
   @venues.each do |poi|
     name = poi.name 
     address = poi.location.address
     new_poi = Point_Of_Interest.new(name, address)
     $poi_array.push(new_poi)
   end    
   $poi_array
  end
  
  def find_flickr_pictures(name)
    FlickRaw.api_key = get_flickr_key
    FlickRaw.shared_secret = get_flickr_secret
    flickr.photos.search(:api_key => get_flickr_key, :text => name)
  end
  
end



class TripsController < ApplicationController
  
     
  before_action :set_trip, only: [:show, :edit, :update, :destroy]
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
  
  def set_trip
      @trip = Trip.find(params[:id])
    end
    
  def trip_params
    params.require(:trip).permit(:place)
  end
  
end

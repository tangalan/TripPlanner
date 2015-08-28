module ApplicationHelper 
  
  Point_Of_Interest = Struct.new :name, :address
  Restaurant = Struct.new :name, :address
    
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
  
  def get_google_key 
    google_key = "AIzaSyB_6XEWPpo8UG8eaZXTwWqFuh8t3qNxIVY"
  end
  
  def find_pois
   puts "finding pois"
   $poi_array = Array.new
   client = Foursquare2::Client.new(:client_id => get_foursquare_client_id, :client_secret => get_foursquare_client_secret)
   @venues = client.search_venues_by_tip(:near => @trip.place, :query => 'attractions', :limit => 10, :v => 20150821) 
   @venues.each do |poi|
     name = poi.name 
     puts name
     address = poi.location.address
     puts address
     new_poi = Point_Of_Interest.new(name, address)
     $poi_array.push(new_poi)
   end    
   $poi_array
  end
  
  def find_flickr_pois(name, number_of_photos)
    FlickRaw.api_key = get_flickr_key
    FlickRaw.shared_secret = get_flickr_secret
    flickr.photos.search(:api_key => get_flickr_key, :text => name, :per_page => number_of_photos)
  end
  
  def find_poi_urls(poi_name, number_to_display)
    puts "querying " + poi_name
    url_array = Array.new 
    results = (find_flickr_pois("\"" + poi_name + "\"", number_to_display)) #escaped quotes to make search more specific
    results.size
    # if results shown exceeds number of photos we want to display
    if (results.size > 0)
      0.upto(number_to_display) do |n|
        unless (results[n].nil?) then 
          info = flickr.photos.getInfo(:photo_id => results[n].id) 
          url = FlickRaw.url_b(info)   
          url_array.push(url)      
        end 
      end
    end
    url_array
  end

def find_restaurants
   puts "finding restaurants"
   $restaurant_array = Array.new
   client = Foursquare2::Client.new(:client_id => get_foursquare_client_id, :client_secret => get_foursquare_client_secret)
   @venues = client.search_venues_by_tip(:near => @trip.place, :query => 'restaurants', :limit => 10, :v => 20150821) 
   @venues.each do |restaurant|
     name = restaurant.name 
     puts name
     address = restaurant.location.address
     puts address
     new_restaurant = Restaurant.new(name, address)
     $restaurant_array.push(new_restaurant)
   end    
   $restaurant_array
  end
  
  def find_flickr_restaurants(name, number_of_photos)
    FlickRaw.api_key = get_flickr_key
    FlickRaw.shared_secret = get_flickr_secret
    flickr.photos.search(:api_key => get_flickr_key, :text => name, :per_page => number_of_photos)
  end
  
  def find_restaurant_urls(restaurant_name, number_to_display)
    puts "querying " + restaurant_name
    url_array = Array.new 
    results = (find_flickr_restaurants("\"" + restaurant_name + "\"", number_to_display)) #escaped quotes to make search more specific
    results.size
    # if results shown exceeds number of photos we want to display
    if (results.size > 0)
      0.upto(number_to_display) do |n|
        unless (results[n].nil?) then 
          info = flickr.photos.getInfo(:photo_id => results[n].id) 
          url = FlickRaw.url_b(info)   
          url_array.push(url)      
        end 
      end
    end
    url_array
  end
  
end 


class TripsController < ApplicationController
  include ApplicationHelper
     
  before_action :set_trip, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!,  except: [:welcome]
  
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
    puts "Place: " + @trip.place
    
    if @trip.save
      find_pois.each do |poi|
        name = poi.name
        address = poi.address + ", " + @trip.place #makes sure address is in that city and not too generic
        @trip.pois.create(:name => name, :address => address)
        puts "created POI " + name.to_s
      end 
      
      find_restaurants.each do |restaurant|
        name = restaurant.name
        address = restaurant.address + ", " + @trip.place
        @trip.restaurants.create(:name => name, :address => address)
        puts "created restaurant " + name.to_s
      end 
      
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
  
  def map 
    @trip = Trip.find(params[:id])
    render 'map'
  end
 
  
  private
  
  def set_trip
      @trip = Trip.find(params[:id])
    end
    
  def trip_params
    params.require(:trip).permit(:place)
  end
  
end

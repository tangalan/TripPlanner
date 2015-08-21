


class PoisController < ApplicationController
  
  def index
    @pois = Poi.all
  end
  
  
  def create
    @trip = Trip.find(params[:trip_id])
    @poi = @trip.pois.create(comment_params)
    redirect_to trip_path(@trip)
  end
  
  def destroy
    @trip = Trip.find(params[:trip_id])
    @poi = @trip.pois.find(params[:id])
    @poi.destroy
    redirect_to trip_path(@trip)
  end
  
  private
    def comment_params
      params.require(:poi).permit(:poi)
    end
  
end

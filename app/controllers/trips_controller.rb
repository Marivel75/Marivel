class TripsController < ApplicationController
  before_action :set_trip, only: [:show, :edit, :update, :destroy]
  before_action :is_current_user?, except: [:show, :index, :search]

  def index
    @trips = Trip.published.includes(:category).all
  end

  # GET /trips/1
  # GET /trips/1.json
  def show
    gon.trip = @trip
    gon.trip_waypoints = []
    @trip.trip_waypoints.each do |n|
      gon.trip_waypoints.push(n.place)
    end
    # gon.waypoints_rank = []
    # @trip.trip_waypoints.each do |r|
    #   gon.waypoints_rank.push(r.rank)
    # end
    # gon.routingProfiles = []
    # Category.all.each do |c|
    #   gon.routingProfiles << c.name
    # end
  end

  # GET /trips/new
  def new
    @trip = Trip.new
    @categories = Category.all.map{|c| [ c.name, c.id ] }
    @new_place = Place.new()
  end

  # GET /trips/1/edit
  def edit
    @new_place = Place.new()
    @categories = Category.all.map{|c| [ c.name, c.id ] }
  end

  # POST /trips
  # POST /trips.json
  def create
    @trip = Trip.new(trip_params)
    @trip.category_id = params[:category_id]
    @trip.author = current_user
    @categories = Category.all.map{|c| [ c.name, c.id ] }

    respond_to do |format|
      if @trip.save
        format.html { redirect_to @trip, notice: "L'itinéraire a été crée." }
        format.json { render :show, status: :created, location: @trip }
      else
        format.html { render :new }
        format.json { render json: @trip.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /trips/1
  # PATCH/PUT /trips/1.json
  def update
    @trip.update(trip_params)
    redirect_to trip_path(@trip[:id]), notice: "Les modifications ont été enregistrées."

    # @trip.category_id = params[:category_id]
    # respond_to do |format|
    #   if @trip.update(trip_params)
    #     format.html { redirect_to trip_path(@trip[:id]), notice: 'Trip was successfully updated.' }
    #     format.json { render :show, status: :ok, location: @trip }
    #   else
    #     format.html { render :edit }
    #     format.json { render json: @trip.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # DELETE /trips/1
  # DELETE /trips/1.json
  def destroy
    @trip.destroy
    respond_to do |format|
      format.html { redirect_to trips_url, alert: "L'itinéraire a été supprimé." }
      format.json { head :no_content }
    end
  end

  private

    def set_trip
      if params[:id]
        @trip = Trip.find(params[:id])
        gon.places = @trip.places.all
      end
    end

    def trip_params
      params.require(:trip).permit(:title, :description, :category_id, :trip_picture, :tag_list, :attribution_photo)
    end

    def is_current_user?
      set_trip
       if !current_user
        flash.alert = "Veuillez vous connecter"
        redirect_to new_user_session_path
      elsif  @trip && @trip.author != current_user && current_user.role != 'admin'
          flash.alert = "Vous n'avez pas les droits."
          redirect_to @trip
       end
    end
end

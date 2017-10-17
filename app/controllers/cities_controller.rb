require 'wikipedia'
class CitiesController < ApplicationController
  before_action :set_city, only: [:show, :edit, :update, :destroy]

  # GET /cities
  # GET /cities.json
  def index
    @cities = City.all
    if params[:query].present?
      @page = Wikipedia.find(params[:query])
    else 
      @page = Wikipedia.find('wikipedia')
    end
  end

  # GET /cities/1
  # GET /cities/1.json
  def show
    city_name = @city.name
    country_code = @city.country_code
    api = ENV.fetch('WEATHER')
    response = HTTParty.get("http://api.openweathermap.org/data/2.5/weather?q=#{city_name},#{country_code}&appid=#{api}&units=metric")
    @data = response.body
    @temp_min = response['main']['temp_min']
    @temp_max = response['main']['temp_max']
    @humidity = response['main']['humidity']
    @pressure = response['main']['pressure']
    
    
    # This is just for the sake of using cities_helper
    response_kelvin = HTTParty.get("http://api.openweathermap.org/data/2.5/weather?q=#{city_name},#{country_code}&appid=6b7691d7c9453c238ec6a2863c1e5699")
    @temp_max_kelvin = response_kelvin['main']['temp_max']

    # @page = Wikipedia.find('Emma Watson')
    # @title = @page.summary

  end

  # GET /cities/new
  def new
    @city = City.new
  end

  # GET /cities/1/edit
  def edit
  end

  # POST /cities
  # POST /cities.json
  def create
    @city = City.new(city_params)

    respond_to do |format|
      if @city.save
        format.html { redirect_to @city, notice: 'City was successfully created.' }
        format.json { render :show, status: :created, location: @city }
      else
        format.html { render :new }
        format.json { render json: @city.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cities/1
  # PATCH/PUT /cities/1.json
  def update
    respond_to do |format|
      if @city.update(city_params)
        format.html { redirect_to @city, notice: 'City was successfully updated.' }
        format.json { render :show, status: :ok, location: @city }
      else
        format.html { render :edit }
        format.json { render json: @city.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cities/1
  # DELETE /cities/1.json
  def destroy
    @city.destroy
    respond_to do |format|
      format.html { redirect_to cities_url, notice: 'City was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_city
      @city = City.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def city_params
      params.require(:city).permit(:name, :country_code)
    end
end

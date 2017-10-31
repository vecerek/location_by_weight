class MapController < ApplicationController

  def show
    # NEVER DO THIS!!! THIS SHOULD BE SET AS AN ENVIRONMENT VARIABLE ON THE SERVER!!!!
    @api_key = 'AIzaSyCOKCoFxPYNaliB8qMmjHyFEEM07PFn05s'
  end

  def update
    wger_api_key = allowed_params[:api_key]
    response = RestClient::Request.execute(
      method: :get,
      url: 'https://wger.de/api/v2/weightentry/',
      headers: { :Authorization => "Token #{wger_api_key}" }
    )
    response_json = JSON.parse(response.body)
    sum_of_weights = response_json['results'].inject(0) { |sum, e| sum + e['weight'].to_i }
    avg_weight = sum_of_weights/response_json['count'].to_i
    @location = weight_to_location(avg_weight)

    respond_to do |f|
      f.js
      f.json { render json: @location, status: 200, location: @location}
    end
  end

  private

  def allowed_params
    params.require(:wger)
  end

  def weight_to_location(weight)
    if weight < 58
      # asia
      lat = 19.185992
      long = 72.897657
    elsif weight < 61
      #africa
      lat = 3.851147
      long = 44.137464
    elsif weight < 71
      #europe
      lat = 55.649433
      long = 12.542843
    else
      #america
      lat = 31.911443
      long = -99.375185
    end

    { lat: lat, lng: long }
  end
end

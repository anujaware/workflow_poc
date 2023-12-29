class HomeController < ApplicationController
  def index
    #render layout: false
  end

  def fetch_data
    data_hash = {}
    distance_calculation_api_url = "http://sample.net/?dogs=sleet&yam=bait#muscle"
    iot_api_token = "y95LK9yjT9WWd4Jet6ABUF7tFmS0lcqB0KP5Qyh1jVgLP6Vtvrzgg5W59kRfrake"
    rate_api_url = "http://sample.com/?end=turn&swim=sisters"
    fare_calculate_api_url="https://www.sample.edu/?brake=fish&slip=trouble"
    
    if params[:values]
      parameters = params[:values].split(",")
      data_hash[:distance_calculation_api_url] = distance_calculation_api_url if parameters.include?("distance_calculation_api_url")
      data_hash[:iot_api_token] = iot_api_token if parameters.include?("iot_api_token")
      data_hash[:rate_api_url] = rate_api_url if parameters.include?("rate_api_url")
      data_hash[:fare_calculate_api_url] = fare_calculate_api_url if parameters.include?("fare_calculate_api_url")
    end

    render json: {
      data: data_hash
    }
  end
end

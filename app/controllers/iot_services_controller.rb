class IotServicesController < ApplicationController
  before_action :set_workflow, only: %i[ show edit update destroy ]
  
  def get_distance
    pickup_location = 'baner'
    destination = 'balewadi'
    render json: {distance: '6'}
  end

  def get_cost
    distance = params[:distance]
    render json: {cost: '600', unit: 'INR'}
  end

end

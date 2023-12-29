class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token

  def create_records
    # Parse the JSON payload from the request body
    request_data = JSON.parse(request.body.read)

    # Iterate through the parsed data, where each key is a model name and the value is an array of records
    request_data.each do |model_name, records|
      # Find the corresponding ActiveRecord model class based on the model name
      model_class = model_name.constantize

      # Create records for the current model
      records.each do |record_params|
        model_class.create!(record_params)
      end
    end

    #    render json: { message: 'Records created successfully' }, status: :created
#  Respond with a success message or appropriate status code
  rescue StandardError => e
    # Handle any errors that occur during record creation
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def update_records
    # Parse the JSON payload from the request body
    request_data = JSON.parse(request.body.read)

    # Iterate through the parsed data, where each key is a model name and the value is an array of records
    request_data.each do |model_name, records|
      # Find the corresponding ActiveRecord model class based on the model name
      model_class = model_name.constantize

      # Create records for the current model
      records.each do |record_params|
        id = record_params["id"]
        record_params.delete("id")
        model_class.find(id).update!(record_params)
      end
    end

    # Respond with a success message or appropriate status code
    render json: { message: 'Records created successfully' }, status: :created
  rescue StandardError => e
    # Handle any errors that occur during record creation
    render json: { error: e.message }, status: :unprocessable_entity
  end
end

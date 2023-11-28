class WorkflowApisController < ApplicationController

  def zeebe_client
    Zeebe::Client::GatewayProtocol::Gateway::Stub.new('localhost:26500', :this_channel_is_insecure)
  end
  def create
    bpmn_process_id = params[:bpmn_process_id] || 'decide_meal'
    booking_data = params[:vehicle_booking].permit!
    @booking_request = VehicleBooking.create({
      request_id: Time.current.to_i + rand(10),
      status: 'Open'}.merge(booking_data)
    )
    
    process_details = zeebe_client.create_process_instance(
      Zeebe::Client::GatewayProtocol::CreateProcessInstanceRequest.new(
        {
          bpmnProcessId: bpmn_process_id, version: -1,
          variables: booking_data.merge({booking_id: @booking_request.request_id}).to_json
        }
      )
    )

    process_instance_key = process_details.processInstanceKey
    @booking_request.update_attribute(:process_instance_key, process_instance_key)
    #store process key into db
    #ProcessInstance  process_instance_key
    #return process key
    redirect_to vehicle_bookings_url
  end
end

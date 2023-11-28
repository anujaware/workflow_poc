require 'zeebe/client'
class VehicleBookingsController < ApplicationController

  def zeebe_client
    ip = 'localhost' #'35.91.59.107' #localhost
    Zeebe::Client::GatewayProtocol::Gateway::Stub.new("#{ip}:26500", :this_channel_is_insecure)
  end

  def create
    bpmn_process_id = params['vehicle_booking'][:bpmn_process_id] || 'vehicle-booking-receive-task'
    booking_data = params[:vehicle_booking].permit!
    request_id = Time.current.to_i + rand(10)

    process_details = zeebe_client.create_process_instance(
      Zeebe::Client::GatewayProtocol::CreateProcessInstanceRequest.new(
        {
          bpmnProcessId: bpmn_process_id, version: -1,
          variables: booking_data.merge({
            status: 'open',
            request_id: request_id.to_s }).to_json
        }
      )
    )
    redirect_to vehicle_booking_url(request_id.to_s)
  end

  def update
    @booking_request = VehicleBooking.find(params[:id])
    params.permit!
    if @booking_request.present?
      @booking_request.update_attributes(params["vehicle_booking"])
    else
      redirect_to edit_vehicle_booking_path(@booking_request)
    end
  end

  def show 
    @booking_request = VehicleBooking.where("id = ? OR request_id = ?", params[:id], params[:id]).first
    5.times do
      if !@booking_request.present?
        sleep 2
        @booking_request = VehicleBooking.find_by(request_id: params[:id])
        @booking_request = VehicleBooking.find_by(request_id: params[:id].to_i) if !@booking_request.present?
      else
        break
      end
    end
    if @booking_request.present?
      @process_instance_key = @booking_request.process_instance_key.to_i
    else
      redirect_to vehicle_bookings_url
    end
  end

  def edit
    render layout: false
    @booking_request = VehicleBooking.find(params[:id])
    if !@booking_request
      redirect_to vehicle_bookings_url
    end
  end

  def complete
    @booking_request = VehicleBooking.where("id = ? OR request_id = ?",
                                            params[:vehicle_booking_id],
                                            params[:vehicle_booking_id]).first
  end

  def destroy
    vehicle_booking = VehicleBooking.find(params[:id])
    if vehicle_booking.present?
      process_instance_key = vehicle_booking.process_instance_key.to_i
      process_cancel_status = zeebe_client.cancel_process_instance(Zeebe::Client::GatewayProtocol::CancelProcessInstanceRequest.new({processInstanceKey: process_instance_key}))
      p process_cancel_status
      vehicle_booking.update_attribute('status', 'Cancel')
      redirect_to vehicle_bookings_url
    else
      redirect_to vehicle_booking_url(vehicle_booking)
    end
  end

  def index
    render layout: false
    page_no = params[:page_no]
    @booking_requests = VehicleBooking.page(page_no)
  end

  def search
    zeebe_client = Zeebe::Client::GatewayProtocol::Gateway::Stub.new('localhost:26500', :this_channel_is_insecure)

    resp = zeebe_client.activate_jobs(Zeebe::Client::GatewayProtocol::ActivateJobsRequest.new())
    p resp

    #2251799813685298
    process_id = 'preparing-dinner' #user_age
    process_start_resp = zeebe_client.create_process_instance(Zeebe::Client::GatewayProtocol::CreateProcessInstanceRequest.new({bpmnProcessId: process_id, version: -1}))
    p "#{process_start_resp}"

    topology = zeebe_client.topology(Zeebe::Client::GatewayProtocol::TopologyRequest.new)
    puts "Zeebe topology:"
    puts "  Cluster size: #{topology.clusterSize}"
    puts "  Replication factor: #{topology.replicationFactor}"
    puts "  Brokers:"

    topology.brokers.each do |b|
      puts "    - id: #{b.nodeId}, address: #{b.host}:#{b.port}, partitions: #{b.partitions.map { |p| p.partitionId }}"
    end
    # start process
    #

    # Save process details in database

    # send details to user task

    # fetch process data
    #


  end
end

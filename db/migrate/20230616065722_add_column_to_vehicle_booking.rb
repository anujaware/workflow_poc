class AddColumnToVehicleBooking < ActiveRecord::Migration[7.0]
  def change
    add_column :vehicle_bookings, :phone_number, :string
    add_column :vehicle_bookings, :pickup_point, :string
    add_column :vehicle_bookings, :destination, :string
    add_column :vehicle_bookings, :process_instance_key, :string
    add_column :vehicle_bookings, :bpmn_process_id, :string
  end
end

class CreateVehicleBookings < ActiveRecord::Migration[7.0]
  def change
    create_table :vehicle_bookings do |t|
      t.string :request_id
      t.string :workflow_process_id
      t.string :status
      t.float :cost
      t.float :distance
      t.string :currency

      t.timestamps
    end
  end
end

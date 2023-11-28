class CreateWorkflows < ActiveRecord::Migration[7.0]
  def change
    create_table :workflows do |t|
      t.string :name
      t.string :process_id
      t.string :bpmn_diagram_file
      t.string :bpmn_image
      t.string :description

      t.timestamps
    end
  end
end

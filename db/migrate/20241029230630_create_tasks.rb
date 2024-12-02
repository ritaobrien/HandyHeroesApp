class CreateTasks < ActiveRecord::Migration[7.2]
  def change
    create_table :tasks do |t|
      t.string :task_category
      t.string :task_type
      t.text :description
      t.string :status
      t.integer :senior_id
      t.integer :volunteer_id

      t.timestamps
    end
  end
end

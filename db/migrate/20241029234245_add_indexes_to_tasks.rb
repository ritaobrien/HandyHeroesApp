class AddIndexesToTasks < ActiveRecord::Migration[7.2]
  def change
    add_index :tasks, :senior_id
    add_index :tasks, :volunteer_id
  end
end

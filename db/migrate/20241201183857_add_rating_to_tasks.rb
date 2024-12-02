class AddRatingToTasks < ActiveRecord::Migration[7.2]
  def change
    add_column :tasks, :rating, :integer, default: nil, null: true
  end
end

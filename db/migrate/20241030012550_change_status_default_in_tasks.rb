class ChangeStatusDefaultInTasks < ActiveRecord::Migration[7.2]
  def change
    change_column_default :tasks, :status, 'Pending'
  end
end

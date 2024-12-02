class AddCommentToTasks < ActiveRecord::Migration[7.2]
  def change
    add_column :tasks, :comment, :text
  end
end

class AddFieldsToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :county, :string
    add_column :users, :town, :string
    add_column :users, :approved, :boolean, default: false
  end
end

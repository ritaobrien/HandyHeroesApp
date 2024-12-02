class AddTelephoneNumberToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :telephone_number, :string
  end
end

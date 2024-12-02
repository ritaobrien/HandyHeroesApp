class AddDocumentsToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :photo_id, :string
    add_column :users, :id_document, :string
  end
end

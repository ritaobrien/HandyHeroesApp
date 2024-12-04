# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
User.find_or_create_by!(email: "ritateresaobrien@hmail.com") do |user|
    user.first_name:"Rita"
    user.last_name:"OBrien"
    user.county:"Kildare"
    user.town:"Naas"
    user.telephone_number:"0871234567"
    user.email: 'rita.t.obrien@gmail.com',
    user.password = "123456" # Replace with a strong password
    user.password_confirmation: '123456',
    user.role = "admin" # Ensure this matches your enum or role logic
  end



  puts "Admin user created or updated successfully!"
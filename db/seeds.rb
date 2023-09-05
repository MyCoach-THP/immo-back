# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

Property.destroy_all
User.destroy_all

10.times do
  user = User.create!(
    email: Faker::Internet.email,
    password: Faker::Internet.password
  )
end

users = User.all

puts "Users ok"
cities = ["PARIS", "MONTPELLIER", "TOULOUSE", "BORDEAUX", "MARSEILLE", "LILLE", "NICE", "NANTES", "RENNES"]

users.each do |user|
  3.times do
    newCity = cities.sample
    Property.create!(
      user: user,
      title: Faker::Movies::LordOfTheRings.location,
      price: Faker::Number.between(from: 100000, to: 1000000),
      description: Faker::Lorem.paragraph_by_chars(number: 200, supplemental: false),
      city: newCity,
      private: false
    )
  end
end

puts "Properties créées"
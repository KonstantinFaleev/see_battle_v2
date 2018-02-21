namespace :db do
  desc "Fill database with sample data"
  task getSomePirates: :environment do
    Player.create!(name: "Captain Flint",
                   email: "flint@test.com",
                   password: "piastres",
                   password_confirmation: "piastres",
                   rating: 10000,
                   admin: true)
    99.times do |n|
      name  = "Pirate #{Faker::Name.first_name}"
      email = "pirate-#{n+1}@test.com"
      password  = "password"
      Player.create!(name: name,
                     email: email,
                     password: password,
                     password_confirmation: password,
                     rating: rand(10000))
    end
  end
end
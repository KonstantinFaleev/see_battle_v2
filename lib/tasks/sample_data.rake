#require 'faker'

namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    create_admin
    make_bots
  end

  def create_admin
    Player.create!(name: "Captain Flint",
                   email: "flint@test.com",
                   password: "piastres",
                   password_confirmation: "piastres",
                   rating: 10000,
                   admin: true)
  end

  def make_bots
    Player.create!(id: 2,
                   name: "Easy Bot",
                   email: "easybot@sbattle.com",
                   password: "c3w4mlWqYmUYrgn",
                   password_confirmation: "c3w4mlWqYmUYrgn",
                   rating: 10000,
                   admin: true)
    15.times do |n|
      name = Faker::Name.first_name + rand(1000).to_s
      password = "password"
      Player.create!(name: name,
                     email: "",
                     password: password,
                     password_confirmation: password,
                     rating: rand(10000))
    end
  end

end
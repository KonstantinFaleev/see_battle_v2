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
                   rating: 1000,
                   admin: true)
  end

  def make_bots
    15.times do |n|
      name = Faker::Name.first_name + rand(1000).to_s
      password = "password"
      Player.create!(name: name,
                     email: "",
                     password: password,
                     password_confirmation: password,
                     rating: rand(1000))
    end
  end

end
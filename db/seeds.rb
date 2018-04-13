# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

    Player.create(name: 'Captain Flint',
                   email: 'flint@test.com',
                   password: 'piastres',
                   password_confirmation: 'piastres',
                   rating: 10000,
                   admin: true)

    Player.create(id: 2,
                   name: 'Easy Bot',
                   email: 'easybot@sbattle.com',
                   password: 'c3w4mlWqYmUYrgn',
                   password_confirmation: 'c3w4mlWqYmUYrgn',
                   rating: 10000,
                   admin: true)

    #25.times do
    #  name = Faker::Name.first_name + rand(1000).to_s
    #  password = 'password'
    #  Player.create(name: name,
    #                 email: '',
    #                 password: password,
    #                 password_confirmation: password,
    #                 rating: rand(10000))
    #end

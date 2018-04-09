source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.1.6'
gem 'bootstrap-sass', '~> 3.3.1'
gem 'sass-rails'
gem 'autoprefixer-rails'
gem 'bcrypt', '~> 3.1.7'
gem 'faker'
gem 'will_paginate'
gem 'whenever', require: false
gem 'sprockets'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'jquery-rails'
gem 'turbolinks', '~> 5'
gem 'jbuilder', '~> 2.5'
gem 'jquery-ui-rails'
gem 'nokogiri'
gem 'json'
gem 'paranoia', '~> 2.0'
gem 'pg', '>= 0.18', '< 2.0'
gem 'puma', '~> 3.7'
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem 'rubocop', require: false
gem 'responders'
gem 'rails_12factor'
gem 'debase'
gem 'figaro'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'web-console', '>= 3.3.0'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  #gem 'quiet_assets'
  gem 'better_errors'
  gem 'binding_of_caller'
end




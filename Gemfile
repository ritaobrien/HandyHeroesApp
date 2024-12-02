source "https://rubygems.org"

gem "rails", "~> 7.2.1", ">= 7.2.1.1"
gem "sprockets-rails"

gem "puma", ">= 5.0"
gem "importmap-rails"
gem "stimulus-rails"
gem "jbuilder"

gem 'bootstrap', '~> 5.3', '>= 5.3.3'
gem 'dartsass-sprockets'
gem 'jquery-rails'
gem 'popper_js', '~> 2.11.8'

gem 'devise', '~> 4.9', '>= 4.9.4'
gem 'premailer-rails'

gem "tzinfo-data", platforms: %i[ windows jruby ]

gem "bootsnap", require: false

group :development, :test do
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
end

group :development do
    gem "sqlite3", ">= 1.4"
    gem "web-console"
end

group :production do
  gem 'pg', '~> 1.5', '>= 1.5.9'
  gem 'rails_12factor', '~> 0.0.3'
end

group :test do
   gem "capybara"
  gem "selenium-webdriver"
end

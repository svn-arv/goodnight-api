source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails', branch: 'main'
gem 'rails', '~> 7.2.1'
# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem 'sprockets-rails'
# Use sqlite3 as the Database
# Chosen for its simplicity and ease of use for small projects like now
gem 'sqlite3', '>= 1.4'
# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '>= 5.0'
# Authentication and authorization for Rails [https://github.com/heartcombo/devise]
gem 'devise'
# History and versioning for Rails models [https://github.com/paper-trail-gem/paper_trail]
gem 'paper_trail', '~> 16.0'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[windows jruby]

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

# Pagination for Rails [https://github.com/kaminari/kaminari]
gem 'kaminari'

# DB Locking for Rails [https://github.com/ankane/with_advisory_lock]
# SQLite: File Locks
# PostgreSQL & MySQL: Table/Row Locks
gem 'with_advisory_lock', '~> 5.1.0'

group :development, :test do
  gem 'annotate'
  gem 'dotenv-rails', '~> 3.1.7'
  gem 'factory_bot_rails'
  # Static analysis for security vulnerabilities [https://brakemanscanner.org/]
  gem 'brakeman', require: false
  # Debugger for Ruby [https://github.com/deivid-rodriguez/byebug]
  gem 'byebug'
  # Seed data for development and testing environments [https://github.com/faker-ruby/faker]
  gem 'faker'
  # Code completion for Ruby [https://solargraph.org/]
  gem 'solargraph'
  gem 'solargraph-rails'
  # Best practices for Rails applications [https://github.com/rails/rails_best_practices]
  gem 'rails_best_practices', require: false
  # Test framework for Rails applications [https://rspec.info/]
  gem 'rspec-rails', '~> 7.1.1'
  # Code style for Ruby [https://rubocop.org/]
  gem 'rubocop'
  gem 'rubocop-factory_bot'
  gem 'rubocop-performance'
  gem 'rubocop-rspec'
  gem 'rubocop-rspec_rails'
  # Code coverage for Ruby [https://simplecov.org/]
  gem 'simplecov'

  # Time related helpers for testing [https://github.com/travisjeffery/timecop]
  gem 'timecop'
end

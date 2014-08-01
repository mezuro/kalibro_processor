source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.4'

# Use sqlite3 as the database for Active Record
gem 'sqlite3'

# Use PostgreSQL as the database for Active Record
gem 'pg'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.1'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', :platforms => :ruby

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'

# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', require: false

# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
gem 'spring', group: :development

# Communication with other parts
gem 'kalibro_gatekeeper_client', '~> 0.1.1'

# YAML parser required for properly compactibility between mri and rbx
gem 'psych', '~>2.0.5'

# Repository cloning
gem 'git', '~> 1.2.7'

# Clean the database for acceptance test
gem 'database_cleaner', require: false

# Create a processing queue
gem 'delayed_job_active_record', '~> 4.0.1'

# Required for workers creation
gem 'daemons', '~> 1.1.9'

group :test do
  # Easier test writing
  gem "shoulda-matchers", '~>2.6.1'

  # Test coverage
  gem 'simplecov', require: false

  # Simple Mocks
  gem 'mocha', :require => 'mocha/api'
end

group :development, :test do
  # Test framework
  gem 'rspec-rails', '~> 3.0.1'

  # Fixtures made easy
  gem 'factory_girl_rails', '~> 4.4.1'
end

# Acceptance tests
group :cucumber do
  gem 'cucumber', '~> 1.3.10'
  gem 'cucumber-rails'
  # gem 'database_cleaner' # Removed because it is getting added above.
end

# Some statistics
gem 'descriptive-statistics', '~> 2.1.2'

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]

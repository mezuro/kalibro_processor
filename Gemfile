source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.0'

# Use sqlite3 as the database for Active Record
gem 'sqlite3'

# Use PostgreSQL as the database for Active Record
gem 'pg'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0.0.beta1'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.1.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'

# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use Rails Html Sanitizer for HTML sanitization
gem 'rails-html-sanitizer', '~> 1.0'

# Kalibro integration
gem 'kalibro_client'

# YAML parser required for properly compactibility between mri and rbx
gem 'psych', '~>2.0.12'

# Repository cloning
gem 'git', '~> 1.2.7'

# Clean the database for acceptance test
# Version should be greater than 1.4.1. See:
# https://github.com/DatabaseCleaner/database_cleaner/issues/317
gem 'database_cleaner', '>= 1.4.1', require: false

# Create a processing queue
gem 'delayed_job_active_record', '~> 4.0.1'

# Required for workers creation
gem 'daemons', '~> 1.1.9'

# Sends a email whenever there is a unexpected exception
gem 'exception_notification', '~> 4.0.1'

group :test do
  # Easier test writing
  gem "shoulda-matchers", '~>2.8.0'

  # Test coverage
  gem 'simplecov', require: false

  # Test Coverage monitoring
  gem "codeclimate-test-reporter", require: nil

  # Simple Mocks
  gem 'mocha', :require => 'mocha/api'
end

group :development, :test do
  # Call 'debugger' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # Access an IRB console on exceptions page and /console in development
  gem 'web-console', '~> 2.0.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring', group: :development

  # Test framework
  gem 'rspec-rails', '~> 3.2.0'

  # Fixtures made easy
  gem 'factory_girl_rails', '~> 4.5.0'

  # Deployment
  gem 'capistrano', "~>3.4.0", require: false
  gem 'capistrano-rails'
  gem 'capistrano-bundler'
  gem 'capistrano-rvm', "~>0.1.0"
end

# Acceptance tests
group :cucumber do
  gem 'cucumber', '~> 1.3.10'
  gem 'cucumber-rails'
  # gem 'database_cleaner' # Removed because it is getting added above.
end

# Some statistics
gem 'descriptive-statistics', '~> 2.1.2'

# Ruby Collector
gem 'metric_fu', '~> 4.11.1'
gem 'debug_inspector' # this is a dependency after updating metric_fu to 4.11.4

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]

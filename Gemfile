source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.2'

# Use Puma as the app server
gem 'puma', '~> 3.0'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors'
gem 'active_model_serializers', '~> 0.10.5'
#stripe for credit card payments
gem 'stripe', '~> 3.3', '>= 3.3.1'
#figaro gem for securely managing credentials
gem 'figaro', '~> 1.1', '>= 1.1.1'
#dwolla for funds transfers
gem 'dwolla_v2', '~> 2.0'
#plaid to handle auth for dwolla
gem 'plaid'
#work accurately with currencies
gem 'money-rails', '~>1'

#used to store encrypted data in DB
gem 'attr_encrypted', '~> 3.1'

group :development, :test do
  # Use sqlite3 as the database for Active Record
  gem 'sqlite3'
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
  gem 'rspec-rails', '~> 3.5'
end
 
group :test do
  gem 'shoulda-matchers', '~> 3.0', require: false
  gem 'faker', '~> 1.6.1'
end

group :development do
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :production do
  gem 'pg', '~> 0.18.4'
end
# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# ActiveAdmin
gem 'devise', '~> 4.2'
gem 'activeadmin', github: 'activeadmin'
gem 'inherited_resources', git: 'https://github.com/activeadmin/inherited_resources'

#authentication
gem 'bcrypt', '~> 3.1', '>= 3.1.11'
gem 'knock', '~> 2.1', '>= 2.1.1'
source 'https://rubygems.org'

ruby '2.4.1'

gem 'rails', '~> 5.0.3'
gem 'mysql2', '~> 0.4.5'
gem 'puma', '~> 3.9.1'
gem 'sass-rails', '~> 5.0.6'
gem 'bootstrap-sass', '~> 3.3.6'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.2.1'
gem 'therubyracer', '~> 0.12.3'
gem 'jquery-rails'
gem 'jquery-ui-rails', '~> 6.0.1'
gem 'turbolinks', '~> 5.0.1'
gem 'jbuilder', '~> 2.6.3'
gem 'bcrypt', '~> 3.1.11'
gem 'seed-fu', '~> 2.3.6'
gem 'enum_help', '~> 0.0.17'
gem 'carrierwave', '~> 1.0.0'
gem 'mini_magick', '~> 4.5.1'
gem 'acts-as-taggable-on', '~> 5.0'
gem 'gon', '~> 6.0.1'
gem 'data-confirm-modal', '~> 1.3.0'
gem 'kaminari', '~> 1.0.1'
gem 'config', '~> 1.4.0'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  gem 'annotate', github: 'ctran/annotate_models'
  gem 'pry-rails', '~> 0.3.5'
  gem 'pry-byebug', '~> 3.4.2'
  gem 'factory_girl_rails', '~> 4.8.0'
  gem 'rspec-rails', '~> 3.6.0'
  gem 'faker', '~> 1.6.3'
  gem 'timecop', '~> 0.8.1'
end

group :development, :staging, :production do
  gem 'fog-aws', '~> 1.3.0'
  gem 'fog', '~> 1.40.0', require: 'fog/aws/storage'
  gem 'aws-ses', '~> 0.6'
  gem 'aws-sdk', '~> 2.9.38'
end

group :development do
  gem 'web-console', '~> 3.4.0'
  gem 'listen', '~> 3.0.5'
  gem 'letter_opener', '~> 1.4.1'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'rubocop', '~> 0.47.1', require: false
  gem 'bullet', '~> 5.5.1'

  gem 'capistrano', '~> 3.8.1'
  gem 'capistrano-rails', '~> 1.3.0'
  gem 'capistrano-rbenv', '~> 2.1.1'
  gem 'capistrano3-puma', '~> 3.1.0'
  gem 'capistrano-bundler', '~> 1.2.0'
  gem 'capistrano-rbenv-vars', '~> 0.1.0'
end

group :test do
  gem 'capybara', '~> 2.14.0'
  gem 'poltergeist', '~> 1.15.0'
  gem 'database_cleaner', '~> 1.5.3'
  gem 'rails-controller-testing', '~> 1.0.1'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

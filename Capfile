# Load DSL and set up stages
require 'capistrano/setup'

# require 'capistrano/rvm'
require 'capistrano/rbenv'

# Include default deployment tasks
require 'capistrano/deploy'

require 'capistrano/bundler'
require 'capistrano/rails/assets'
require 'capistrano/rails/migrations'
require 'capistrano3/unicorn'
require 'whenever/capistrano'

Dir.glob("lib/capistrano/tasks/*.rake").each { |r| import r }

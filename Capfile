require 'capistrano/setup'

# Includes default deployment tasks
require 'capistrano/rbenv'
require 'capistrano/deploy'
require 'capistrano/bundler'
require 'capistrano/rails/assets'
# require 'capistrano/rails or capistrano/rails/migrations'
require 'capistrano/puma'
require 'capistrano/scm/git'
require 'capistrano/rbenv_vars'

install_plugin Capistrano::SCM::Git
install_plugin Capistrano::Puma

Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }

require 'aws-sdk'

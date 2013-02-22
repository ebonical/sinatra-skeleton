require "bundler"
require "sinatra"
Bundler.require(:default, settings.environment)

class App < Sinatra::Base
  register Sinatra::Contrib
  register Sinatra::ActiveRecordExtension

  set :root, File.dirname(__FILE__)
  set :views, Proc.new { File.join(root, "app/views") }
  require File.join(root, "config/database.rb")
  # sprockets environment
  set :sprockets, Sprockets::Environment.new(root)
  set :assets_prefix, "/assets"
  set :precompile, [ Proc.new{ |path| !File.extname(path).in?(['.js', '.css']) },
                     /application\.(css|js)$/ ]
  # Don't fallback to assets pipeline if a precompiled asses is missing
  set :compile_assets, !production?
  # Generate digests for assets URLs
  set :digest_assets, production?
  set :assets_path, Proc.new { File.join(public_folder, assets_prefix) }

  # Require models
  Dir[File.join(root, "app/models/*.rb")].each { |file| require file }

  configure do
    # Setup Sprockets
    sprockets.append_path "app/assets/stylesheets"
    sprockets.append_path "app/assets/javascripts"
    sprockets.append_path "app/assets/images"

    # Configure Sprockets::Helpers (if necessary)
    Sprockets::Helpers.configure do |config|
      config.environment = sprockets
      config.prefix      = assets_prefix
      config.digest      = digest_assets
      config.public_path = public_folder
    end
  end

  helpers do
    Dir[File.join(root, "app/helpers/*.rb")].each do |file|
      require file
      include File.basename(file, File.extname(file)).camelize.constantize
    end
    include Sprockets::Helpers
  end

  get "/" do
    haml :index
  end
end

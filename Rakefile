require "sinatra/activerecord/rake"
require "./app"

task :environment do
  #
end

namespace :assets do
  desc "Compile all the assets"
  task :precompile => :environment do
    settings = App.settings
    sprockets = App.sprockets
    target = Pathname.new File.join(settings.public_folder, settings.assets_prefix)
    manifest = {}

    settings.precompile.each do |path|
      sprockets.each_logical_path do |logical_path|
        case path
        when Regexp
          next unless path.match(logical_path)
        when Proc
          next unless path.call(logical_path)
        else
          next unless File.fnmatch(path.to_s, logical_path)
        end

        if asset = sprockets.find_asset(logical_path)
          asset_path = settings.digest_assets ? asset.digest_path : logical_path
          manifest[logical_path] = asset_path
          filename = target.join(asset_path)

          mkdir_p filename.dirname
          asset.write_to(filename)
          asset.write_to("#{filename}.gz") if filename.to_s =~ /\.(css|js)$/
          # Also write undigested asset for direct access
          if settings.digest_assets
            asset.write_to target.join(logical_path)
          end
        end
      end
    end

    File.open("#{target}/manifest.yml", 'w') do |f|
      YAML.dump(manifest, f)
    end
  end

  desc "Remove compiled assets"
  task :clean => :environment do
    public_asset_path = File.join(App.public_folder, App.assets_prefix)
    rm_rf public_asset_path, :secure => true
  end
end

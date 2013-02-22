require "./app"

if App.compile_assets
  map App.assets_prefix do
    run App.sprockets
  end
end

map "/" do
  run App
end

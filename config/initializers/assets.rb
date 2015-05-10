# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'
Rails.application.config.assets.paths << Rails.root.join("app", "assets", "fonts")

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
Rails.application.config.assets.precompile += %w( *.svg *.ttf )
Rails.application.config.assets.precompile << Proc.new do |path|
  # if path =~ /\.(css|js |scss|png|jpg|gif|js on)\z/
    full_path = Rails.application.assets.resolve(path).to_path
    app_assets_path1 = Rails.root.join('app', 'assets').to_path
    app_assets_path2 = Rails.root.join('public', 'assets').to_path
    app_assets_path3 = Rails.root.join('vendor', 'assets').to_path
    if full_path.starts_with? app_assets_path1
      true
    else
      if full_path.starts_with? app_assets_path2
        true
      else
        if full_path.starts_with? app_assets_path3
          true
        else
          false
        end
      end
    end
  # end
end
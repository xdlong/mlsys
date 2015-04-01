# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
Rails.application.config.assets.precompile += %w( base/sidenav.js base/handlebars.js base/base.css fontawesome/font-awesome.min.css bootstrap/bootstrap.min.css bootstrap/bootstrap.css.map bootstrap/bootstrap-theme.min.css bootstrap/bootstrap-theme.css.map erp/reg.js basic.js bootstrap/bootstrap.min.js )
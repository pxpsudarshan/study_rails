# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = "1.0"

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
# Rails.application.config.assets.precompile += %w( admin.js admin.css )
Rails.application.config.assets.precompile += ['icon.png','favicon.ico']
Rails.application.config.assets.precompile += ['login.css','sb-admin-2']
Rails.application.config.assets.precompile += ['html5shiv.js', 'mains.js']
Rails.application.config.assets.precompile += %w( locales/ja/common.messages.js )

Rails.application.config.assets.precompile += ['users.js', 'kaisha/company_stores.js', 'kaisha/job_profiles.js']
Rails.application.config.assets.precompile += ['kaisha/comps.js', 'kaisha/menus.js', 'menus.js', 'stores.js', 'kaisha/offers.js']


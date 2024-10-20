# config/initializers/active_storage.rb
Rails.application.config.active_storage.variant_processor = :mini_magick
Rails.application.config.after_initialize do
  ActiveStorage::BaseController.class_eval do
    before_action :authenticate_user!
  end
end

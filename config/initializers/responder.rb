# need for devise when using mobile
ActionController::Responder.class_eval do
  alias :to_mobile :to_html
end
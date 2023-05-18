ActionView::Base.field_error_proc = proc do |html_tag, instance|
  h = html_tag.gsub("form-control", "form-control is-invalid").html_safe
  h.gsub("form-select", "form-select is-invalid").html_safe
end

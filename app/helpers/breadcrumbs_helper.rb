module BreadcrumbsHelper
  def add_resource_breadcrumb(resource, show_path = nil)
    return unless resource.present?
    
    # Get resource name or title if available
    label = if resource.respond_to?(:name)
              resource.name
            elsif resource.respond_to?(:title)
              resource.title
            else
              resource.to_s
            end
    
    add_breadcrumb(label, show_path)
  end
end
# Breadcrumbs Usage Guide

The application now includes automatic breadcrumb generation for all controllers. Here's how it works:

## Basic Functionality

- Every page automatically gets breadcrumbs through the `BreadcrumbsConcern`
- The home page is always the first breadcrumb
- The current controller name is automatically added as a breadcrumb
- The current action (if not index) is automatically added as the last breadcrumb

## Adding Resource-Specific Breadcrumbs

For controllers that handle specific resources, you can add the resource name to the breadcrumbs:

```ruby
def show
  add_resource_breadcrumb(@resource, resource_path(@resource))
end

def edit
  add_resource_breadcrumb(@resource, resource_path(@resource))
  add_breadcrumb(t('breadcrumbs.edit'))
end
```

## Adding Custom Breadcrumbs

You can add custom breadcrumbs in any action:

```ruby
add_breadcrumb("Custom Step", custom_path)
```

## Translations

Breadcrumb labels are automatically translated using the following convention:

```yaml
en:
  breadcrumbs:
    home: "Home"
    controller_name: "Controller Label"
    action_name: "Action Label"
```

These translations are defined in `config/locales/breadcrumbs.{en,ja}.yml`
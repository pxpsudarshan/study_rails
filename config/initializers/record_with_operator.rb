Warden::Manager.after_set_user do |resource, _auth, _opts|
  RecordWithOperator.operator = resource if resource.present?
end

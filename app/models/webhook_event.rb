class WebhookEvent < ApplicationRecord
  acts_as_paranoid
  records_with_operator_on :create, :update, :destroy

  enum state: { pending: 0, processing: 1, processed: 2, failed: 3 }
end

class Store < ApplicationRecord
  acts_as_paranoid
  records_with_operator_on :create, :update, :destroy
  belongs_to :user

  has_many :store_contents, dependent: :destroy
  accepts_nested_attributes_for :store_contents, allow_destroy: true
end

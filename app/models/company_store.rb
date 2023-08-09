class CompanyStore < ApplicationRecord
  acts_as_paranoid
  records_with_operator_on :create, :update, :destroy
  belongs_to :comp

  has_many :company_store_contents, dependent: :destroy
  accepts_nested_attributes_for :company_store_contents, allow_destroy: true
end

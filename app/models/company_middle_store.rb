class CompanyMiddleStore < ApplicationRecord
  acts_as_paranoid
  records_with_operator_on :create, :update, :destroy
  belongs_to :user

  validates :vocab_code, presence: true
  validates :vocab_read, presence: true
  validates :vocab_mean, presence: true
  validates :occupation, presence: true
end

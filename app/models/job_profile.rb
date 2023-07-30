class JobProfile < ApplicationRecord
  acts_as_paranoid
  records_with_operator_on :create, :update, :destroy
  belongs_to :comp

  has_many :job_profile_contents, dependent: :destroy
  accepts_nested_attributes_for :job_profile_contents, allow_destroy: true
end

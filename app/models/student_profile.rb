class StudentProfile < ApplicationRecord
  acts_as_paranoid
  records_with_operator_on :create, :update, :destroy
  belongs_to :user

#  validates :ad_title, presence: true
  validates :occupation, presence: true
  validates :location, presence: true
  validates :visa_support, inclusion: [true, false]
  validates :year, presence: true
  validates :month, presence: true
  validates :visa_type, presence: true
#  validates :employment_sts, presence: true
  validates :salary, presence: true
  validates :job_description, presence: true


end

class Profile < ApplicationRecord
  acts_as_paranoid
  records_with_operator_on :create, :update, :destroy
  belongs_to :user

  has_one_attached :photo, dependent: :destroy

  has_many :profile_languages, dependent: :destroy
  accepts_nested_attributes_for :profile_languages, allow_destroy: true

  has_many :profile_works, dependent: :destroy
  accepts_nested_attributes_for :profile_works, allow_destroy: true

  validates :kokuseki, presence: true
  validates :birthday, presence: true
  validates :visa_type, presence: true
  validates :visa_end_date, presence: true
  validates :address, presence: true

  has_many :profile_qualifications, dependent: :destroy
  accepts_nested_attributes_for :profile_qualifications, allow_destroy: true  
end

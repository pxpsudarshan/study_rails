class Profile < ApplicationRecord
  acts_as_paranoid
  records_with_operator_on :create, :update, :destroy
  belongs_to :user

  has_many :profile_languages, dependent: :destroy
  accepts_nested_attributes_for :profile_languages, allow_destroy: true

  has_many :profile_works, dependent: :destroy
  accepts_nested_attributes_for :profile_works, allow_destroy: true
end

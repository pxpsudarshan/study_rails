class Tokutei < ApplicationRecord
  acts_as_paranoid
  records_with_operator_on :create, :update, :destroy

  has_many :contents, foreign_key: :tokutei_id, class_name: 'Tokutei', dependent: :destroy
  accepts_nested_attributes_for :contents, allow_destroy: true

  has_many :languages, as: :langs, dependent: :destroy
  accepts_nested_attributes_for :languages, allow_destroy: true

  has_many :tokutei_questions, dependent: :destroy
  accepts_nested_attributes_for :tokutei_questions, allow_destroy: true

  default_scope -> { order(:sort) }

  validates :title, presence: true
end

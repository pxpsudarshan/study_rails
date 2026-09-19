class PartsTable < ApplicationRecord
  acts_as_paranoid
  records_with_operator_on :create, :update, :destroy

  has_many :parts_kanjis, dependent: :destroy

  has_many :kanji_tables, through: :parts_kanjis
  accepts_nested_attributes_for :kanji_tables, allow_destroy: true

  validates :parts_code, presence: true
end

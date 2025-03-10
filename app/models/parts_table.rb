class PartsTable < ApplicationRecord
  acts_as_paranoid
  records_with_operator_on :create, :update, :destroy

  has_many :parts_kanjis, dependent: :destroy
  has_many :kanji_tables, through: :parts_kanjis
end

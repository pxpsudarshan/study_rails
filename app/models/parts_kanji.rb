class PartsKanji < ApplicationRecord
  acts_as_paranoid
  records_with_operator_on :create, :update, :destroy

  belongs_to :parts_table
  belongs_to :kanji_table
end

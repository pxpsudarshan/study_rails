class KanjiVocab < ApplicationRecord
  acts_as_paranoid
  records_with_operator_on :create, :update, :destroy

  belongs_to :kanji_table
  belongs_to :vocab_table
end

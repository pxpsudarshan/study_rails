class KanjiTable < ApplicationRecord
  acts_as_paranoid
  records_with_operator_on :create, :update, :destroy

  has_many :parts_kanjis, dependent: :destroy
  has_many :parts_tables, through: :parts_kanjis

  has_many :kanji_vocabs, dependent: :destroy
  has_many :vocab_tables, through: :kanji_vocabs
end

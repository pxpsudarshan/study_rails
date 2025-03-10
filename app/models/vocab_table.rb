class VocabTable < ApplicationRecord
  acts_as_paranoid
  records_with_operator_on :create, :update, :destroy

  has_many :vocab_nations, dependent: :destroy

  has_many :kanji_vocabs, dependent: :destroy
  has_many :kanji_tables, through: :kanji_vocabs

  has_many :read_vocabs, dependent: :destroy
  has_many :read_tables, through: :read_vocabs
end

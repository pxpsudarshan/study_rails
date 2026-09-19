class VocabTable < ApplicationRecord
  acts_as_paranoid
  records_with_operator_on :create, :update, :destroy

  has_many :vocab_nations, dependent: :destroy
  accepts_nested_attributes_for :vocab_nations, allow_destroy: true

  has_many :kanji_vocabs, dependent: :destroy
  accepts_nested_attributes_for :kanji_vocabs, allow_destroy: true

  has_many :kanji_tables, through: :kanji_vocabs

  has_many :vocab_mycards, dependent: :destroy

  has_many :vocab_genre_contents, dependent: :destroy
  accepts_nested_attributes_for :vocab_genre_contents, allow_destroy: true

  belongs_to :channel, optional: true

  validates :sort, presence: true
  validates :vocab_code, presence: true
  validates :vocab_read, presence: true
  validates :jlpt_level, presence: true

  scope :comp_vocab_tables, -> (comp_id) { where(channel_id: [nil, comp_id]) }

end

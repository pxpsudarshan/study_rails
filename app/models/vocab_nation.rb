class VocabNation < ApplicationRecord
  acts_as_paranoid
  records_with_operator_on :create, :update, :destroy

  belongs_to :vocab_table

  validates :sort, presence: true
  validates :lang, presence: true
#  validates :nation_code, presence: true

  default_scope { order(lang: :asc) }
end

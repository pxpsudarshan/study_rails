class VocabGenreContent < ApplicationRecord
  acts_as_paranoid
  records_with_operator_on :create, :update, :destroy
  belongs_to :vocab_genre
  belongs_to :vocab_table

  validates :sort, presence: true
end

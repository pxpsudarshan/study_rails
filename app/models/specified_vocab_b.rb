class SpecifiedVocabB < ApplicationRecord
  acts_as_paranoid
  records_with_operator_on :create, :update, :destroy

  belongs_to :specified_vocab_a
end

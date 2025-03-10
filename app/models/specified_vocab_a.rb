class SpecifiedVocabA < ApplicationRecord
  acts_as_paranoid
  records_with_operator_on :create, :update, :destroy

  has_many :specified_vocab_bs, dependent: :destroy
  accepts_nested_attributes_for :specified_vocab_bs, allow_destroy: true
end

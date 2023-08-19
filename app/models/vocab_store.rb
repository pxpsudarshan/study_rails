class VocabStore < ApplicationRecord
  acts_as_paranoid
  records_with_operator_on :create, :update, :destroy
  has_many :vocab_mycards, foreign_key: 'vocab_org', primary_key: 'vocab_org'
end

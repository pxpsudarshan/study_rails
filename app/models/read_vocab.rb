class ReadVocab < ApplicationRecord
  acts_as_paranoid
  records_with_operator_on :create, :update, :destroy

  belongs_to :vocab_table
  belongs_to :read_table
end

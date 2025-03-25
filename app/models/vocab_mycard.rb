class VocabMycard < ApplicationRecord
  acts_as_paranoid
  records_with_operator_on :create, :update, :destroy
  belongs_to :user
  belongs_to :vocab_table
end

class VocabMycard < ApplicationRecord
  acts_as_paranoid
  records_with_operator_on :create, :update, :destroy
  belongs_to :user
  belongs_to :vocab_store, foreign_key: :vocab_org, primary_key: :vocab_org, class_name: 'VocabStore'
end

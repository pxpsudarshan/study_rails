class ReadTable < ApplicationRecord
  acts_as_paranoid
  records_with_operator_on :create, :update, :destroy

  has_many :read_vocabs, dependent: :destroy
  has_many :vocab_tables, through: :read_vocabs
end

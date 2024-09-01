class SpecifiedVocabA < ApplicationRecord
  acts_as_paranoid
  records_with_operator_on :create, :update, :destroy

  # has_many :tokutei_bs, dependent: :destroy
end

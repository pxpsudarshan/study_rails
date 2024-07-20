class TokuteiB < ApplicationRecord
  acts_as_paranoid
  records_with_operator_on :create, :update, :destroy

  belongs_to :tokutei_a
  has_many :tokutei_cs, dependent: :destroy
end

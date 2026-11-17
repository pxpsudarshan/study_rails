class VocabMycard < ApplicationRecord
  acts_as_paranoid
  records_with_operator_on :create, :update, :destroy
  scope :for_learning_period, -> (period) {
    start_date = case period
                 when '1d' then 1.day.ago
                 when '1m' then 1.month.ago
                 when '3m' then 3.months.ago
                 end
    start_date ? where(updated_at: start_date..Time.current) : all
  }

  belongs_to :user
  belongs_to :vocab_table
end

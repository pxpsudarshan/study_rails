class SswExpl < ApplicationRecord
  has_many :ssw_expllimbs
  belongs_to :ssw_prob
end

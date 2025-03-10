class SswProb < ApplicationRecord
  has_many :ssw_problimbs
  has_one :ssw_expl
  belongs_to :ssw_title
end

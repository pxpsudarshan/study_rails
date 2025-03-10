class SswTitle < ApplicationRecord
  has_many :ssw_probs
  belongs_to :ssw_titlec
end

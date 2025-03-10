class SswTitlec < ApplicationRecord
  has_many :ssw_titles
  belongs_to :ssw_titleb
end

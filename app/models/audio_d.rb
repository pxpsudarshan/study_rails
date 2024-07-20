class AudioD < ApplicationRecord
  acts_as_paranoid
  records_with_operator_on :create, :update, :destroy

  belongs_to :audio_c

  has_one_attached :mpg
end

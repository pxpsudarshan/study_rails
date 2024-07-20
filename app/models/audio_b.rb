class AudioB < ApplicationRecord
  acts_as_paranoid
  records_with_operator_on :create, :update, :destroy

  belongs_to :audio_a
  has_many :audio_cs, dependent: :destroy
end

class AudioC < ApplicationRecord
  acts_as_paranoid
  records_with_operator_on :create, :update, :destroy

  belongs_to :audio_b
  has_many :audio_ds, dependent: :destroy
end

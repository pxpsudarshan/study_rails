class AudioA < ApplicationRecord
  acts_as_paranoid
  records_with_operator_on :create, :update, :destroy

  has_many :audio_bs, dependent: :destroy
end

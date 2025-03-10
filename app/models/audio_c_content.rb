class AudioCContent < ApplicationRecord
  acts_as_paranoid
  records_with_operator_on :create, :update, :destroy
  belongs_to :audio_c

  has_many :audio_ds, dependent: :destroy

  has_many :languages, as: :langs, dependent: :destroy
  accepts_nested_attributes_for :languages, allow_destroy: true

  validates :content, presence: true
end

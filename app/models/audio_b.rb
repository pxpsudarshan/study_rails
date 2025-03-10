class AudioB < ApplicationRecord
  acts_as_paranoid
  records_with_operator_on :create, :update, :destroy

  belongs_to :audio_a

  has_many :audio_cs, dependent: :destroy

  has_many :languages, as: :langs, dependent: :destroy
  accepts_nested_attributes_for :languages, allow_destroy: true

  validates :title_nation, presence: true

end

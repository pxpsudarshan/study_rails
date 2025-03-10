class TokuteiExplain < ApplicationRecord
  acts_as_paranoid
  records_with_operator_on :create, :update, :destroy
  belongs_to :explains, polymorphic: true

  has_one_attached :image, dependent: :destroy
  has_one_attached :audio, dependent: :destroy

  has_many :languages, as: :langs, dependent: :destroy
  accepts_nested_attributes_for :languages, allow_destroy: true
  before_save :update_image_flg

  def update_image_flg
    self.image_flg = self.image.attached? ? true : false
  end
end

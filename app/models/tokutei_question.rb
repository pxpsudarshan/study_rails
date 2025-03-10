class TokuteiQuestion < ApplicationRecord
  acts_as_paranoid
  records_with_operator_on :create, :update, :destroy

  belongs_to :tokutei

  has_one_attached :image, dependent: :destroy
  has_one_attached :audio, dependent: :destroy

  has_many :tokutei_answers, dependent: :destroy
  accepts_nested_attributes_for :tokutei_answers, allow_destroy: true

  has_many :languages, as: :langs, dependent: :destroy
  accepts_nested_attributes_for :languages, allow_destroy: true

  has_one :tokutei_explain, as: :explains, dependent: :destroy
  accepts_nested_attributes_for :tokutei_explain, allow_destroy: true

  validates :title, presence: true
  validates :content, presence: true

  default_scope -> { order(:sort) }

  before_save :update_image_flg

  def update_image_flg
    self.image_flg = self.image.attached? ? true : false
  end
end

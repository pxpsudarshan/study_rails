class Channel < ApplicationRecord
  acts_as_paranoid
  records_with_operator_on :create, :update, :destroy

  has_many :comps, dependent: :destroy
  accepts_nested_attributes_for :comps, allow_destroy: true

  has_many :user_channels, dependent: :destroy
  accepts_nested_attributes_for :user_channels, allow_destroy: true

  has_many :vocab_tables, dependent: :destroy
  accepts_nested_attributes_for :vocab_tables, allow_destroy: true

  has_many :vocab_genres, dependent: :destroy
  accepts_nested_attributes_for :vocab_genres, allow_destroy: true

  validates :channel_name, presence: true
end

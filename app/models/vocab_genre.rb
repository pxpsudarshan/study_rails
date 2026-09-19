class VocabGenre < ApplicationRecord
  acts_as_paranoid
  records_with_operator_on :create, :update, :destroy
  belongs_to :vocab_genre, optional: true

  belongs_to :channel, optional: true

  has_many :vocab_genre_contents, dependent: :destroy
  accepts_nested_attributes_for :vocab_genre_contents, allow_destroy: true

  has_many :vocab_tables, through: :vocab_genre_contents
  accepts_nested_attributes_for :vocab_tables, allow_destroy: true

  has_many :sub_genres, foreign_key: :vocab_genre_id, class_name: 'VocabGenre', dependent: :destroy
  accepts_nested_attributes_for :sub_genres, allow_destroy: true

  has_many :languages, as: :langs, dependent: :destroy
  accepts_nested_attributes_for :languages, allow_destroy: true

  default_scope -> { order(:sort) }

  validates :title, presence: true
end

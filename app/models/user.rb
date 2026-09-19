class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :rememberable, :timeoutable, :lockable #, :validatable
  acts_as_paranoid
  records_with_operator_on :create, :update, :destroy

  has_one_attached :avatar

  has_one :profile, dependent: :destroy
  accepts_nested_attributes_for :profile, allow_destroy: true

  has_one :store, dependent: :destroy

  has_many :vocab_mycards, dependent: :destroy
  
  belongs_to :comp, optional: true
  has_many :user_channels, dependent: :destroy
  accepts_nested_attributes_for :user_channels, allow_destroy: true

  validates :sei, presence: true
  validates :mei, presence: true
  validates :sei_kana, presence: true
  validates :mei_kana, presence: true
  validates :mobile, presence: true

  validates :email, presence: true, if: :email_required?
  validates :email, format: { with: Devise.email_regexp, allow_blank: true, if: :email_changed? }

  validates :lang_id, presence: true

  validates :password, presence: true, if: :password_required?
  validates :password, confirmation: true, if: :password_required?
  validates :password, length: { within: Devise.password_length, allow_blank: true }
  validate :password_complexity

  validates_as_paranoid
  validates_uniqueness_of_without_deleted :email

  before_save :set_access_type

  def password_complexity
    if password.present? and !password.match(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)./)
      errors.add(:password, I18n.t('exception.invalid_password'))
    end
  end

  def name
    (sei.present? ? sei : '') +' '+ (mei.present? ? mei : '')
  end

  def name_kana
    (sei_kana.present? ? sei_kana : '') +' '+ (mei_kana.present? ? mei_kana : '')
  end

  module ACCESS_TYPE
    KANRISHA = 30
    POWER_USER = 20
    USER = 0
  end

  private

  def set_access_type
    #self.access_type = ACCESS_TYPE::USER if self.access_type == 0
  end

  def password_required?
    !persisted? || !password.nil? || !password_confirmation.nil?
  end

  def email_required?
    true
  end
end

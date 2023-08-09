class Comp < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :rememberable, :timeoutable #, :validatable
  acts_as_paranoid
  records_with_operator_on :create, :update, :destroy

  has_one_attached :avatar

  has_one :company_store, dependent: :destroy
  has_one :job_profile, dependent: :destroy

  validates :company_name, presence: true
  validates :business_type, presence: true
  validates :company_url, presence: true
  validates :department, presence: true

  validates :sei, presence: true
  validates :mei, presence: true
  validates :sei_kana, presence: true
  validates :mei_kana, presence: true
  validates :mobile, presence: true

  validates :email, presence: true, if: :email_required?
  validates :email, format: { with: Devise.email_regexp, allow_blank: true, if: :email_changed? }
  validates :password, presence: true, if: :password_required?
  validates :password, confirmation: true, if: :password_required?
  validates :password, length: { within: Devise.password_length, allow_blank: true }
  validate :password_complexity

  validates_as_paranoid
  validates_uniqueness_of_without_deleted :email

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

  private

  def password_required?
    !persisted? || !password.nil? || !password_confirmation.nil?
  end

  def email_required?
    true
  end
end

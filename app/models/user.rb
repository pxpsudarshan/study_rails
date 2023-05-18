class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :rememberable, :timeoutable #, :validatable
  acts_as_paranoid
  records_with_operator_on :create, :update, :destroy

  has_one_attached :avatar

  has_many :vocab_mycards

  has_many :job_profiles, dependent: :destroy
  accepts_nested_attributes_for :job_profiles, allow_destroy: true
  #Add Student_profile 20230513
  has_many :student_profiles, dependent: :destroy
  accepts_nested_attributes_for :student_profiles, allow_destroy: true
  #Add Student_profile 20230513
  has_many :company_middle_stores, dependent: :destroy
  accepts_nested_attributes_for :company_middle_stores, allow_destroy: true

  validates :company_name, presence: true, if: :company?
  validates :business_type, presence: true, if: :company?
  validates :company_url, presence: true, if: :company?
  validates :department, presence: true, if: :company?

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

  def company?
    company_flg == true
  end

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

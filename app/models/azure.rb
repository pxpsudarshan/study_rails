class Azure < ApplicationRecord
  acts_as_paranoid
  records_with_operator_on :create, :update, :destroy

  validates :access_key, presence: true
  validates :subdomain, presence: true

  validate :check_auth, if: :enable_check_auth?

  private

  def enable_check_auth?
    enable_check_auth
  end

  def check_auth
    return unless errors.empty?

    resp = AzureApi::Base.new(self).check_azure_auth

    case resp.status
    when 302
      errors.add(:base, :url)
    else
      hash = JSON.parse(resp.body)
#      errors.add(:base, hash['message']) if hash['code'] == "GAIA_AP01"
      errors.add(:base, 'Error Auth.')
    end

  rescue AzureApiAuthError
    errors.add(:base, :azure_auth_error)
  rescue Faraday::Error::ConnectionFailed
    errors.add(:base, :azure_conn_error)
  end
end

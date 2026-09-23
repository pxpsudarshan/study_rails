class YoutubeController < Admin::VideoBaseController
  rescue_from YoutubeApi::Error, with: :connection_error

  def connect
    state = SecureRandom.hex(32)
    url = YoutubeApi.authorization_url(state)
    session[:youtube_oauth] = { state: state, user_id: current_user.id, expires_at: 10.minutes.from_now.to_i }
    redirect_to url, allow_other_host: true, status: :see_other
  end

  def callback
    response.headers['Referrer-Policy'] = 'no-referrer'
    pending = session.delete(:youtube_oauth)
    unless pending && pending['user_id'] == current_user.id && pending['expires_at'].to_i > Time.current.to_i &&
        ActiveSupport::SecurityUtils.secure_compare(pending['state'].to_s, params[:state].to_s)
      raise YoutubeApi::Error, 'Start with Connect YouTube in Video learning, then finish the Google sign-in.'
    end
    raise YoutubeApi::Error, 'YouTube connection was cancelled. You can try connecting again.' if params[:error].present?
    raise YoutubeApi::Error, 'Google did not return an authorization code. Please reconnect.' if params[:code].blank?
    tokens = YoutubeApi.exchange(params[:code])
    YoutubeConnection.find_or_initialize_by(user: current_user).store_tokens!(tokens)
    redirect_to admin_video_lessons_path, notice: t('video_learning.youtube.connected')
  end

  def disconnect
    session.delete(:youtube_oauth)
    YoutubeConnection.find_by(user: current_user)&.destroy!
    redirect_to admin_video_lessons_path, notice: t('video_learning.youtube.disconnected'), status: :see_other
  end

  private

  def connection_error(error)
    redirect_to admin_video_lessons_path, alert: error.message
  end
end

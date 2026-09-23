class Admin::VideoBaseController < ApplicationController
  before_action :require_video_manager

  private

  def require_video_manager
    head :forbidden unless current_user && [User::ACCESS_TYPE::KANRISHA, User::ACCESS_TYPE::POWER_USER].include?(current_user.access_type)
  end

  def managed(scope)
    current_user.comp&.channel_id.present? ? scope.where(channel_id: current_user.comp.channel_id) : scope
  end
end

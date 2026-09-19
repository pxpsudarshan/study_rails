class Admin::ChannelsController < ApplicationController
  def index
    @channels = Channel.order(:channel_name)
    @channels = @channels.where(channel_id: params[:search][:channel_id]) if params[:search].present? && params[:search][:channel_id].present?
    @channels = @channels.page(params[:page]).per(params[:per])
    respond_to do |format|
      format.html
      format.js
    end    
  end

  def show
  end

  def new
    @channel = Channel.new
  end

  def create
    @channel = Channel.new
    @channel.assign_attributes(channel_params)
    begin
      ActiveRecord::Base.transaction() do
        if @channel.save
          redirect_to admin_channels_path, flash: {success: t('message.success_completed')}
        else
          render 'new'
        end
      end
    rescue => e
      logger.error(e.message)
      redirect_to admin_channels_path, flash: {alert: e.message}
    end
  end

  def edit
    @channel = Channel.find(params[:id])
  end

  def update
    @channel = Channel.find(params[:id])
    @channel.assign_attributes(channel_params)
    begin
      ActiveRecord::Base.transaction() do
        if @channel.save
          redirect_to admin_channels_path, flash: {success: t('message.success_completed')}
        else
          render 'edit'
        end
      end
    rescue => e
      logger.error(e.message)
      redirect_to admin_channels_path, flash: {alert: e.message}
    end
  end
  
  def destroy
    @channel = Channel.find(params[:id])
    begin
      ActiveRecord::Base.transaction() do
        @channel.destroy!
        redirect_to admin_channels_path, flash: {success: t('message.success_completed')}
      end
    rescue => e
      logger.error(e.message)
      redirect_to admin_channels_path, flash: {alert: e.message}
    end
  end

  private

  def channel_params
    params.require(:channel).permit(
      :channel_name,
    )
  end
end

class Admin::BlockIpsController < ApplicationController
  def index
    @block_ips = BlockIp.order(:created_at, :ipaddr)
    @block_ips = @block_ips.where(ipaddr: params[:search][:ipaddr]) if params[:search].present? && params[:search][:ipaddr].present?
    @block_ips = @block_ips.page(params[:page]).per(params[:per])
    respond_to do |format|
      format.html
      format.js
    end    
  end

  def show
  end

  def new
    @block_ip = BlockIp.new
  end

  def create
    @block_ip = BlockIp.new
    @block_ip.assign_attributes(block_ip_params)
    begin
      ActiveRecord::Base.transaction() do
        if @block_ip.save
          redirect_to admin_block_ips_path, flash: {success: t('message.success_completed')}
        else
          render 'new'
        end
      end
    rescue => e
      logger.error(e.message)
      redirect_to admin_block_ips_path, flash: {alert: e.message}
    end
  end

  def edit
    @block_ip = BlockIp.find(params[:id])
  end

  def update
    @block_ip = BlockIp.find(params[:id])
    @block_ip.assign_attributes(block_ip_params)
    begin
      ActiveRecord::Base.transaction() do
        if @block_ip.save
          redirect_to admin_block_ips_path, flash: {success: t('message.success_completed')}
        else
          render 'edit'
        end
      end
    rescue => e
      logger.error(e.message)
      redirect_to admin_block_ips_path, flash: {alert: e.message}
    end
  end
  
  def destroy
    @block_ip = BlockIp.find(params[:id])
    begin
      ActiveRecord::Base.transaction() do
        @block_ip.destroy!
        redirect_to admin_block_ips_path, flash: {success: t('message.success_completed')}
      end
    rescue => e
      logger.error(e.message)
      redirect_to admin_block_ips_path, flash: {alert: e.message}
    end
  end

  private

  def block_ip_params
    params.require(:block_ip).permit(
      :ipaddr,
    )
  end
end

class Kaisha::CompsController < ApplicationController
  skip_before_action :authenticate_users, only: [:invite]
  before_action :parent, except: [:index, :new, :create]

  def index
    redirect_to edit_kaisha_comp_path(id: current_comp.id) and return if current_comp.access_type == Comp::ACCESS_TYPE::OTHER
    @comps = Comp.order(access_type: :desc).order(:company_name) if current_comp.access_type == Comp::ACCESS_TYPE::KANRIGAISHA
    @comps = Comp.where(comp_id: current_comp.id).order(access_type: :desc).order(:company_name) if current_comp.access_type == Comp::ACCESS_TYPE::PARTNER
    @comps = @comps.where(compid: params[:search][:compid]) if params[:search].present? && params[:search][:compid].present?
    @comps = @comps.page(params[:page]).per(params[:per])
    respond_to do |format|
      format.html
      format.js
    end
  end

  def new
    redirect_to edit_kaisha_comp_path(id: current_comp.id) and return if current_comp.access_type == Comp::ACCESS_TYPE::OTHER
    @comp = Comp.new(comp_id: current_comp.id, access_type: Comp::ACCESS_TYPE::OTHER) if current_comp.access_type == Comp::ACCESS_TYPE::PARTNER
    @comp = Comp.new if current_comp.access_type == Comp::ACCESS_TYPE::KANRIGAISHA
  end

  def show
  end

  def edit
  end

  def update
    @comp.assign_attributes(comp_params)
    begin
      ActiveRecord::Base.transaction() do
        if @comp.save
          redirect_to kaisha_comps_path, flash: {success: t('message.success_completed')}
        else
          render 'edit'
        end
      end
    rescue => e
      logger.error(e.message)
      redirect_to kaisha_comps_path, flash: {alert: e.message}
    end
  end

  def create
    @comp = Comp.new(comp_params)
    begin
      ActiveRecord::Base.transaction() do
        if @comp.save
          redirect_to kaisha_comps_path, flash: {success: t('message.success_completed')}
        else
          render 'new'
        end
      end
    rescue => e
      logger.error(e.message)
      redirect_to kaisha_comps_path, flash: {alert: e.message}
    end
  end

  def destroy
    begin
      ActiveRecord::Base.transaction() do
        @comp.destroy!
        redirect_to kaisha_comps_path
      end
    rescue => e
      logger.error(e.message)
      redirect_to kaisha_comps_path, flash: {alert: e.message}
    end
  end

  def invite
    user_count = @comp.user_count
    current_user_count = @comp.users.count
    if current_user_count < user_count
      redirect_to new_user_kaisha_user_path(id: params[:id])
    else
      redirect_to root_path, flash: {alert: 'User Over Limit.'}
    end
  end

  private

  def parent
    @comp = Comp.find(params[:id])
  end

  def comp_params
    params.require(:comp).permit(
      :email,
      :password,
      :password_confirmation,
      :sei,
      :mei,
      :sei_kana,
      :mei_kana,
      :mobile,
      :comp_id,
      :user_count,
      :login_flg,
      :access_type,
      :company_name, :business_type, :company_url, :department,
    )
  end
end

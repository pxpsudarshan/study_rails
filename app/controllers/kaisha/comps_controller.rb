class Kaisha::CompsController < ApplicationController
  before_action :parent, except: [:index, :new]

  def index
    @comps = Comp.all
    @comps = @comps.where(compid: params[:search][:compid]) if params[:search].present? && params[:search][:compid].present?
    @comps = @comps.page(params[:page]).per(params[:per])
    respond_to do |format|
      format.html
      format.js
    end
  end

  def new
    @comp = Comp.new
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

  def new_store
#    @comp.company_middle_stores.new
    @stores = @comp.company_middle_stores.new
  end

  def create_store
    stores = []
    comp_params[:company_middle_stores_attributes].each do |key, value|
      stores << value.except(:_destroy)
    end
    @stores = @comp.company_middle_stores.new(stores)
    begin
      ActiveRecord::Base.transaction() do
        if @comp.save
          redirect_to kaisha_comps_path, flash: {success: t('message.success_completed') }
        else
          render 'new_store'
        end
      end
    rescue => e
      logger.error(e.message)
      redirect_to kaisha_comps_path, flash: {alert: e.message}
    end
  end

  def new_job_profile
#    @comp.company_middle_stores.new
    @job_profiles = @comp.job_profiles.new
  end

  def create_job_profile
    job_profiles = []
    comp_params[:job_profiles_attributes].each do |key, value|
      job_profiles << value.except(:_destroy)
    end
    @job_profiles = @comp.job_profiles.new(job_profiles)
    begin
      ActiveRecord::Base.transaction() do
        if @comp.save
          redirect_to kaisha_comps_path, flash: {success: t('message.success_completed') }
        else
          render 'new_job_profile'
        end
      end
    rescue => e
      logger.error(e.message)
      redirect_to kaisha_comps_path, flash: {alert: e.message}
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
      :company_name, :business_type, :company_url, :department,
    )
  end
end

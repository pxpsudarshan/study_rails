class Kaisha::CompanyStoresController < ApplicationController
  before_action :parent

  def index
  end

  def new
    @company_store = @comp.company_store
    @company_store ||= @comp.build_company_store
    @company_store_contents = @company_store.company_store_contents.new
  end

  def create
    @company_store = @comp.build_company_store(company_store_params)
    @company_store_contents = @company_store.company_store_contents
    begin
      ActiveRecord::Base.transaction() do
        if @company_store.save
          redirect_to new_kaisha_company_store_path, flash: {success: t('message.success_completed') }
        else
          render 'new'
        end
      end
    rescue => e
      logger.error(e.message)
      redirect_to new_kaisha_company_store_path, flash: {alert: e.message}
    end
  end

  def update
    stores = []
    company_store_params[:company_store_contents_attributes].each do |key, value|
      stores << value.except(:_destroy)
    end
    @company_store = @comp.company_store
    @company_store_contents = @company_store.company_store_contents.new(stores)
    begin
      ActiveRecord::Base.transaction() do
        if @company_store.save
          redirect_to new_kaisha_company_store_path, flash: {success: t('message.success_completed') }
        else
          render 'new'
        end
      end
    rescue => e
      logger.error(e.message)
      redirect_to new_kaisha_company_store_path, flash: {alert: e.message}
    end
  end

  private

  def parent
    @comp = current_comp
  end

  def company_store_params
    params.require(:company_store).permit(
      company_store_contents_attributes: [
        :id,
        :occupation,
        :vocab_code,
        :vocab_read,
        :vocab_mean,
        :_destroy
      ],
    )
  end
end

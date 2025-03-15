class StoresController < ApplicationController
  before_action :parent
  before_action :add_index_breadcrumb, only: [:create,:update]

  def index
  end

  def new
    @store = @user.store
    @store ||= @user.build_store
    @store_contents = @store.store_contents.new
    add_breadcrumb('Stores')
  end

  def create
    add_breadcrumb('create')
    @store = @user.build_store(store_params)
    @store_contents = @store.store_contents
    begin
      ActiveRecord::Base.transaction() do
        if @store.save
          redirect_to new_store_path, flash: {success: t('message.success_completed') }
        else
          render 'new'
        end
      end
    rescue => e
      logger.error(e.message)
      redirect_to new_store_path, flash: {alert: e.message}
    end
  end

  def update
    stores = []
    store_params[:store_contents_attributes].each do |key, value|
      stores << value.except(:_destroy)
    end
    @store = @user.store
    @store_contents = @store.store_contents.new(stores)
    begin
      ActiveRecord::Base.transaction() do
        if @store.save
          redirect_to new_store_path, flash: {success: t('message.success_completed') }
        else
          render 'new'
        end
      end
    rescue => e
      logger.error(e.message)
      redirect_to new_store_path, flash: {alert: e.message}
    end
  end

  private

  def parent
    @user = current_user
  end

  def store_params
    params.require(:store).permit(
      store_contents_attributes: [
        :id,
        :occupation,
        :vocab_code,
        :vocab_read,
        :vocab_mean,
        :use,
        :_destroy
      ],
    )
  end

  def add_index_breadcrumb
    add_breadcrumb('Stores', stores_path)
  end
end

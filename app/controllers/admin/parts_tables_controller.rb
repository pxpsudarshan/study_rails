class Admin::PartsTablesController < ApplicationController
  def index
    @parts_table = PartsTable.order(:parts_stroke)
    if params[:search].present?
      @parts_table = @parts_table.where(parts_code: params[:search][:parts_code]) if params[:search][:parts_code].present?
      @parts_table = @parts_table.joins(:kanji_tables).where(kanji_tables: { kanji_code: params[:search][:kanji_body] }) if params[:search][:kanji_body].present?
    end
    @parts_table = @parts_table.page(params[:page]).per(params[:per])
  end

  def new
    @parts_table = PartsTable.new
  end

  def create
    @parts_table = PartsTable.new(parts_table_params)
    begin
      if @parts_table.save
        redirect_to admin_parts_tables_path, flash: {success: 'Created'}
      else
        render 'new'
      end
    rescue => e
      redirect_to admin_parts_tables_path, flash: {alert: e.message}
    end
  end

  def edit
    @parts_table = PartsTable.find(params[:id])
  end

  def update
    @parts_table = PartsTable.find(params[:id])
    @parts_table.assign_attributes(parts_table_params)
    begin
      if @parts_table.save
        redirect_to admin_parts_tables_path, flash: {success: 'Updated'}
      else
        render 'edit'
      end
    rescue => e
      redirect_to admin_parts_tables_path, flash: {alert: e.message}
    end
  end

  def destroy
    @parts_table = PartsTable.find(params[:id])
    begin
      ActiveRecord::Base.transaction() do
        @parts_table.destroy!
        redirect_to admin_parts_tables_path, flash: {success: 'Deleted'}
      end
    rescue => e
      logger.error(e.message)
      redirect_to admin_parts_tables_path, flash: {alert: e.message}
    end
  end

  private

  def parts_table_params
    params.require(:parts_table).permit(
      :parts_code,
      :sort,
      kanji_tables_attributes: [
        :id,
        :kanji_code,
        :_destroy
      ]
    )
  end
end

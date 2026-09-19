class Admin::KanjiTablesController < ApplicationController
  def index
    @kanji_table = KanjiTable.order(:sort)
    if params[:search].present?
      @kanji_table = @kanji_table.where(kanji_code: params[:search][:kanji_code]) if params[:search][:kanji_code].present?
      @kanji_table = @kanji_table.joins(:parts_tables).where(parts_tables: { parts_code: params[:search][:parts_body] }) if params[:search][:parts_body].present?
      @kanji_table = @kanji_table.joins(:vocab_tables).where(vocab_tables: { vocab_code: params[:search][:vocab_body] }) if params[:search][:vocab_body].present?
    end
    @kanji_table = @kanji_table.page(params[:page]).per(params[:per])
  end

  def new
    @kanji_table = KanjiTable.new
  end

  def create
    @kanji_table = KanjiTable.new(kanji_table_params)
    begin
      if @kanji_table.save
        redirect_to admin_kanji_tables_path, flash: {success: 'Created'}
      else
        render 'new'
      end
    rescue => e
      redirect_to admin_kanji_tables_path, flash: {alert: e.message}
    end
  end

  def edit
    @kanji_table = KanjiTable.find(params[:id])
  end

  def update
    @kanji_table = KanjiTable.find(params[:id])
    @kanji_table.assign_attributes(kanji_table_params)
    begin
      if @kanji_table.save
        redirect_to admin_kanji_tables_path, flash: {success: 'Updated'}
      else
        render 'edit'
      end
    rescue => e
      redirect_to admin_kanji_tables_path, flash: {alert: e.message}
    end
  end

  def destroy
    @kanji_table = KanjiTable.find(params[:id])
    begin
      ActiveRecord::Base.transaction() do
        @kanji_table.destroy!
        redirect_to admin_kanji_tables_path, flash: {success: 'Deleted'}
      end
    rescue => e
      logger.error(e.message)
      redirect_to admin_kanji_tables_path, flash: {alert: e.message}
    end
  end

  private

  def kanji_table_params
    params.require(:kanji_table).permit(
      :kanji_code,
      :sort,
      parts_kanjis_attributes: [
        :id,
        :sort,
        :parts_table_id,
        :kanji_table_id,
        :parts_code_tmp,
        :_destroy
      ],
      vocab_tables_attributes: [
        :id,
        :sort,
        :vocab_code,
        :vocab_read,
        :jlpt_level,
        :example,
        :hide_flg,
        :_destroy
      ]
    )
  end
end

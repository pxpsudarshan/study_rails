class Admin::VocabTablesController < ApplicationController
  def index
    @vocab_table = VocabTable.order(:vocab_read)
    @vocab_table = @vocab_table.where(channel_id: current_user.comp.channel_id) if current_user.comp&.channel_id.present?
    if params[:search].present?
      @vocab_table = @vocab_table.where(vocab_code: params[:search][:vocab_code]) if params[:search][:vocab_code].present?
      @vocab_table = @vocab_table.where("vocab_read LIKE ?", "%#{params[:search][:vocab_read]}%") if params[:search][:vocab_read].present?
      @vocab_table = @vocab_table.where(jlpt_level: params[:search][:jlpt_level]) if params[:search][:jlpt_level].present?
    end
    @vocab_table = @vocab_table.page(params[:page]).per(params[:per])
  end

  def new
    @vocab_table = VocabTable.new
    @vocab_table.channel_id = current_user.comp.channel_id if current_user.comp&.channel_id.present?
  end

  def create
    page = 1
    @vocab_table = VocabTable.new(vocab_table_params)
    @vocab_table.channel_id = current_user.comp.channel_id if current_user.comp&.channel_id.present?
    begin
      if VocabTable.where(vocab_code: @vocab_table.vocab_code).exists?
        redirect_to admin_vocab_tables_path, flash: {alert: 'Already Exists.'}
      elsif @vocab_table.save
        VocabTable.select("id, row_number() over (order by vocab_read) as row_number").each do |data|
          page = (data.row_number-1) / 50 + 1 if data.id == @vocab_table.id
        end
        redirect_to admin_vocab_tables_path(page: page), flash: {success: 'Created'}
      else
        render 'new'
      end
    rescue => e
      redirect_to admin_vocab_tables_path, flash: {alert: e.message}
    end
  end

  def edit
    @vocab_table = VocabTable.find(params[:id])
  end

  def update
    page = 1
    @vocab_table = VocabTable.find(params[:id])
    @vocab_table.assign_attributes(vocab_table_params)
    begin
      if @vocab_table.save
        VocabTable.select("id, row_number() over (order by vocab_read) as row_number").each do |data|
          page = (data.row_number-1) / 50 + 1 if data.id == @vocab_table.id
        end
        redirect_to admin_vocab_tables_path(page: page), flash: {success: 'Updated'}
      else
        render 'edit'
      end
    rescue => e
      redirect_to admin_vocab_tables_path, flash: {alert: e.message}
    end
  end

  def destroy
    @vocab_table = VocabTable.find(params[:id])
    begin
      ActiveRecord::Base.transaction() do
        @vocab_table.destroy!
        redirect_to admin_vocab_tables_path, flash: {success: 'Deleted'}
      end
    rescue => e
      logger.error(e.message)
      redirect_to admin_vocab_tables_path, flash: {alert: e.message}
    end
  end

  def update_vocab_nation_ids
    vocab_nation_ids = params[:ids]
    begin
      vocab_nation_ids.each.with_index(1) do |id, idx|
        vocab_nation = VocabNation.find(id)
        vocab_nation.update_columns(sort: idx)
      end
      render json:  { message: 'updated' }
    rescue => e
      logger.error(e.message)
      render json: { message: e.message }, status: :unprocessable_entity
    end
  end

  private

  def vocab_table_params
    params.require(:vocab_table).permit(
      :sort,
      :vocab_code,
      :vocab_read,
      :jlpt_level,
      :example,
      :hide_flg,
      kanji_vocabs_attributes: [
        :id,
        :sort,
        :kanji_table_id,
        :vocab_table_id,
        :kanji_code_tmp,
        :_destroy
      ],
      vocab_nations_attributes: [
        :id,
        :sort,
        :lang,
        :nation_code,
        :example,
        :hide_flg,
        :_destroy
      ],
      vocab_genre_contents_attributes: [
        :id,
        :sort,
        :vocab_genre_id,
        :hide_flg,
        :_destroy
      ]
    )
  end
end

class Kaisha::OffersController < ApplicationController
  def index
    @genres = VocabGenre.all.map{ |vg| [vg.title, vg.id] } 

    if params[:search].present?
      genre_ids = params[:search][:genre]
      search_mode = params[:search][:search_mode].to_i #0 - company_store, 1 - genre
      rate = params[:search][:rate] || 0

      sub_ids = []
      table_ids = []
      genre_ids.each do |genre_id|
        sub_ids << genre_id
        table_ids = [genre_id]
        while id = table_ids.shift
          vg = VocabGenre.find(id)
          sub_maps = vg.sub_genres.where(hide_flg: false).pluck(:id)
          table_ids += sub_maps
          sub_ids += sub_maps
        end
      end if genre_ids.present?

      stud_arr = {}
      if current_comp.company_store.present? && search_mode == 0
        comp = current_comp.company_store.company_store_contents.map(&:vocab_code)
        comp = comp.where(occupation: params[:search][:occupation]) if params[:search][:occupation].present? && params[:search][:occupation].to_i != 0
        comp_arr = comp

        stud = StoreContent.joins(:store).group(:user_id).select(:user_id).select('ARRAY_AGG("store_contents"."vocab_code") as vocab_code_arr')
        #stud = stud.where(user: id) if params[:search][:user] != 0
        stud.each do |s|
          stud_arr[s.user_id] ||= []
          stud_arr[s.user_id] = s.vocab_code_arr
        end
      end
      comp_arr = VocabTable.joins(:vocab_genre_contents).map(&:vocab_code) if search_mode == 1

      stud = VocabMycard.joins(:vocab_table).group(:user_id).reorder('').select(:user_id).select('ARRAY_AGG("vocab_tables"."vocab_code") as vocab_code_arr')
      stud = stud.joins(vocab_table: :vocab_genre_contents).where(vocab_genre_contents: { vocab_genre_id: sub_ids }) if sub_ids.present? && search_mode == 1
      stud.each do |s|
        stud_arr[s.user_id] ||= []
        stud_arr[s.user_id] = stud_arr[s.user_id] + s.vocab_code_arr
      end

      @stud_rates = {}
      stud_arr.each do |k,v|
        res = 0
        comp_arr.each do |a|
          res += 1 if stud_arr[k].include?(a)
        end
        calc_rate = ((res * 100).to_f / comp_arr.length).round(2)
        if calc_rate >= rate.to_f
          @stud_rates[k] = calc_rate
        end
      end
      a = @stud_rates.sort_by{|k,v| v}.reverse.to_h

      @offers = User.joins(:profile).in_order_of(:id, a.keys)
      @offers = @offers.page(params[:page]).per(params[:per])
    end

    respond_to do |format|
      format.html
      format.js
    end
  end

  def mail_request
    redirect_to kaisha_offers_path, flash: {alert: 'Please select.'} and return if params[:offer].blank?
    ids = params[:offer][:ids]
    email = 'h.renji@hotmail.com,ogadaisuke0303@gmail.com'
    entry_no = User.find(ids).map(&:entry_no).join(', ')
    Kaisha::KaishaMailer.notify(email, current_comp.email, current_comp.company_name, current_comp.business_type, entry_no).deliver_now
  end
end

class Kaisha::OffersController < ApplicationController
  def index
    if params[:search].present? && current_comp.company_store.present?
      comp_arr = []
      comp = current_comp.company_store.company_store_contents
      comp = comp.where(occupation: params[:search][:occupation]) if params[:search][:occupation].present? && params[:search][:occupation].to_i != 0
      comp.each do |c|
        comp_arr << c.vocab_code
      end
      comp_arr = comp_arr.uniq

      stud_arr = {}
      stud = StoreContent.includes(:store).joins(store: :user).order(:store_id)
      #stud = stud.where(user: id) if params[:search][:user] != 0
      stud.each do |s|
        stud_arr[s.store.user_id] ||= []
        stud_arr[s.store.user_id] << s.vocab_code
      end

      stud = VocabMycard.order(:user_id)
      stud.each do |s|
        stud_arr[s.user_id] ||= []
        stud_arr[s.user_id] << s.vocab_code
      end

      stud = VocabMycard.group(:user_id).reorder('').select(:user_id)
      @stud_rates = {}

      rate = params[:search][:rate] || 0
      stud.each do |s|
        res = 0
        comp_arr.each do |a|
          res += 1 if stud_arr[s.user_id].uniq.include?(a)
          #puts stud_arr[s.user_id].uniq
        end
        calc_rate = ((res * 100).to_f / comp_arr.length).round(2)
        if calc_rate >= rate.to_f
          @stud_rates[s.user_id] = calc_rate
        end
      end
      a = @stud_rates.sort_by{|k,v| v}.reverse

      b = []
      a.each { |k,v| b << k }

      @offers = User.joins(:profile).in_order_of(:id, b)
      @offers = @offers.page(params[:page]).per(params[:per])
    end

    respond_to do |format|
      format.html
      format.js
    end
  end
end

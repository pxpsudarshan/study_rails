class PartsKanji < ApplicationRecord
  acts_as_paranoid
  records_with_operator_on :create, :update, :destroy

  belongs_to :parts_table, optional: true
  belongs_to :kanji_table

  attr_accessor :parts_code_tmp

  before_validation :update_parts_kanji

  private
    def update_parts_kanji
      if self.parts_code_tmp.present?
        pt = PartsTable.where(parts_code: self.parts_code_tmp).first
        self.parts_table_id = pt.id if pt.present?
        errors.add(:parts_code, "はパーツテーブルには存在していません。") if pt.blank?
      end
    end
end

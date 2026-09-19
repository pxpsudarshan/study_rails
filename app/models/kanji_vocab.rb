class KanjiVocab < ApplicationRecord
  acts_as_paranoid
  records_with_operator_on :create, :update, :destroy

  belongs_to :kanji_table, optional: true
  belongs_to :vocab_table

  attr_accessor :kanji_code_tmp

  before_validation :update_kanji_vocab

  private
    def update_kanji_vocab
      if self.kanji_code_tmp.present?
        kt = KanjiTable.where(kanji_code: self.kanji_code_tmp).first
        self.kanji_table_id = kt.id if kt.present?
        errors.add(:kanji_code, "は漢字テーブルには存在していません。") if kt.blank?
      end
    end
end

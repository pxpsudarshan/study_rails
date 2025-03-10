class ChangeNull < ActiveRecord::Migration[7.0]
  def change
    execute "UPDATE parts_tables SET sort = 0, created_by = '10876f18-55e1-445f-a7c0-de88491d0292', updated_by = '10876f18-55e1-445f-a7c0-de88491d0292';"
    execute "UPDATE kanji_tables SET sort = 0, created_by = '10876f18-55e1-445f-a7c0-de88491d0292', updated_by = '10876f18-55e1-445f-a7c0-de88491d0292';"
    execute "UPDATE parts_kanjis SET sort = 0, created_by = '10876f18-55e1-445f-a7c0-de88491d0292', updated_by = '10876f18-55e1-445f-a7c0-de88491d0292';"
    execute "UPDATE vocab_tables SET sort = 0, created_by = '10876f18-55e1-445f-a7c0-de88491d0292', updated_by = '10876f18-55e1-445f-a7c0-de88491d0292';"
    execute "UPDATE vocab_nations SET sort = 0, created_by = '10876f18-55e1-445f-a7c0-de88491d0292', updated_by = '10876f18-55e1-445f-a7c0-de88491d0292';"
    execute "UPDATE kanji_vocabs SET sort = 0, created_by = '10876f18-55e1-445f-a7c0-de88491d0292', updated_by = '10876f18-55e1-445f-a7c0-de88491d0292';"
    execute "UPDATE read_tables SET sort = 0, created_by = '10876f18-55e1-445f-a7c0-de88491d0292', updated_by = '10876f18-55e1-445f-a7c0-de88491d0292';"
    execute "UPDATE read_vocabs SET sort = 0, created_by = '10876f18-55e1-445f-a7c0-de88491d0292', updated_by = '10876f18-55e1-445f-a7c0-de88491d0292';"

    change_column_null :parts_tables, :created_by, false
    change_column_null :kanji_tables, :created_by, false
    change_column_null :parts_kanjis, :created_by, false
    change_column_null :vocab_tables, :created_by, false
    change_column_null :kanji_vocabs, :created_by, false
    change_column_null :vocab_nations, :created_by, false
    change_column_null :read_tables, :created_by, false
    change_column_null :read_vocabs, :created_by, false

    change_column_null :parts_tables, :updated_by, false
    change_column_null :kanji_tables, :updated_by, false
    change_column_null :parts_kanjis, :updated_by, false
    change_column_null :vocab_tables, :updated_by, false
    change_column_null :kanji_vocabs, :updated_by, false
    change_column_null :vocab_nations, :updated_by, false
    change_column_null :read_tables, :updated_by, false
    change_column_null :read_vocabs, :updated_by, false

    change_column_null :parts_tables, :sort, false
    change_column_null :kanji_tables, :sort, false
    change_column_null :parts_kanjis, :sort, false
    change_column_null :vocab_tables, :sort, false
    change_column_null :kanji_vocabs, :sort, false
    change_column_null :vocab_nations, :sort, false
    change_column_null :read_tables, :sort, false
    change_column_null :read_vocabs, :sort, false

  end
end

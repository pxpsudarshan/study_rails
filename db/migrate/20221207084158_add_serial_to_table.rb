class AddSerialToTable < ActiveRecord::Migration[7.0]
  def up
    execute "create sequence kanji_stores_kanji_org_seq;"
    execute "alter table kanji_stores alter column kanji_org set default nextval('kanji_stores_kanji_org_seq');"
    add_index :kanji_stores, :kanji_org, unique: true

    execute "create sequence parts_stores_parts_org_seq;"
    execute "alter table parts_stores alter column parts_org set default nextval('parts_stores_parts_org_seq');"
    add_index :parts_stores, :parts_org, unique: true

    execute "create sequence read_stores_read_org_seq;"
    execute "alter table read_stores alter column read_org set default nextval('read_stores_read_org_seq');"
    add_index :read_stores, :read_org, unique: true

    execute "create sequence vocab_stores_vocab_org_seq;"
    execute "alter table vocab_stores alter column vocab_org set default nextval('vocab_stores_vocab_org_seq');"
    add_index :vocab_stores, :vocab_org, unique: true
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end

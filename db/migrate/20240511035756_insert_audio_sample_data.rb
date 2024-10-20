class InsertAudioSampleData < ActiveRecord::Migration[7.0]
  def up
    # Insert data into audio_as table
    execute <<-SQL
      INSERT INTO audio_as (id, title_nation, sort, created_at, updated_at, created_by, updated_by)
      VALUES
      ('db08bafc-c22b-4226-ae93-00a0c7741c48', '{"JP": "宿泊", "EN": "Lodge"}', 1, now(), now(), '10876f18-55e1-445f-a7c0-de88491d0292','10876f18-55e1-445f-a7c0-de88491d0292');
    SQL

    # Insert data into audio_bs table
    execute <<-SQL
      INSERT INTO audio_bs (id, audio_a_id, sort, title_nation, created_at, updated_at, created_by, updated_by)
      VALUES
      ('84ec3667-5079-4932-b70a-16c33e23fee9', 'db08bafc-c22b-4226-ae93-00a0c7741c48', 1, '{"JP": "レストラン", "EN": "Restaurant"}', now(), now(), '10876f18-55e1-445f-a7c0-de88491d0292','10876f18-55e1-445f-a7c0-de88491d0292'),
      ('1ae86799-e722-434c-b9a5-873aa387fce9', 'db08bafc-c22b-4226-ae93-00a0c7741c48', 2, '{"JP": "フロント", "EN": "Front desk"}', now(), now(), '10876f18-55e1-445f-a7c0-de88491d0292','10876f18-55e1-445f-a7c0-de88491d0292');
    SQL

    # Insert data into audio_cs table
    execute <<-SQL
      INSERT INTO audio_cs (id, audio_b_id, title_nation, case_name_nation, title_sort, case_name_sort, created_at, updated_at, created_by, updated_by)
      VALUES
      ('5ea696e8-0347-42cd-ba03-d7739f12fa5d', '1ae86799-e722-434c-b9a5-873aa387fce9', '{"JP": "ようこそ", "EN": "Welcome"}', '{"JP": "通常の場合", "EN": "Normal Pattern"}', 1, 1, now(), now(), '10876f18-55e1-445f-a7c0-de88491d0292','10876f18-55e1-445f-a7c0-de88491d0292'),
      ('b66869e7-3fd0-4ebc-8ec6-4905efca9da6', '1ae86799-e722-434c-b9a5-873aa387fce9', '{"JP": "ようこそ", "EN": "Welcome"}', '{"JP": "ゲストがスリッパの場合", "EN": "guest with sleeper"}', 1, 2, now(), now(), '10876f18-55e1-445f-a7c0-de88491d0292','10876f18-55e1-445f-a7c0-de88491d0292'),
      ('4dec973f-829d-4e7f-a24f-85e5135620ea', '1ae86799-e722-434c-b9a5-873aa387fce9', '{"JP": "ようこそ1", "EN": "Welcome1"}', '{"JP": "ゲストがスリッパの場合1", "EN": "guest with sleeper1"}', 2, 1, now(), now(), '10876f18-55e1-445f-a7c0-de88491d0292','10876f18-55e1-445f-a7c0-de88491d0292'),
      ('5ea696e8-0347-42cd-ba13-d7739f12fa5e', '84ec3667-5079-4932-b70a-16c33e23fee9', '{"JP": "テスト", "EN": "Welcome"}', '{"JP": "通常の場合", "EN": "Normal Pattern"}',	2,	1, now(), now(), '10876f18-55e1-445f-a7c0-de88491d0292','10876f18-55e1-445f-a7c0-de88491d0292'),
      ('b66869e7-3fd0-4ebc-8ed6-4905efca9da7', '84ec3667-5079-4932-b70a-16c33e23fee9', '{"JP": "テスト", "EN": "Welcome"}', '{"JP": "ゲストがスリッパの場合", "EN": "guest with sleeper"}', 2,	2, now(), now(), '10876f18-55e1-445f-a7c0-de88491d0292','10876f18-55e1-445f-a7c0-de88491d0292'),
      ('4dec973f-829d-4e7f-a25f-85e5135620eb', '84ec3667-5079-4932-b70a-16c33e23fee9', '{"JP": "テスト1", "EN": "Welcome1"}', '{"JP": "ゲストがスリッパの場合1", "EN": "guest with sleeper1"}',	3,	1, now(), now(), '10876f18-55e1-445f-a7c0-de88491d0292','10876f18-55e1-445f-a7c0-de88491d0292');
    SQL

    # Insert data into audio_ds table
    execute <<-SQL
      INSERT INTO audio_ds (id, audio_c_id, sort, customer_flag, lang, content, created_at, updated_at, created_by, updated_by)
      VALUES
      ('7212334f-f1ac-4cfb-bffb-e435fbef2552', '5ea696e8-0347-42cd-ba03-d7739f12fa5d', 1, 'f', 'JP', 'おはようございます。お元気ですか。', now(), now(), '10876f18-55e1-445f-a7c0-de88491d0292','10876f18-55e1-445f-a7c0-de88491d0292'),
      ('74bb2bd4-a201-47b6-8327-bd5daae8a14a', '5ea696e8-0347-42cd-ba03-d7739f12fa5d', 2, 't', 'JP', 'はい、元気です。ありがとう。お元気ですか？', now(), now(), '10876f18-55e1-445f-a7c0-de88491d0292','10876f18-55e1-445f-a7c0-de88491d0292'),
      ('a76d2391-e1de-4d6a-af23-a500f2bfe832', '5ea696e8-0347-42cd-ba03-d7739f12fa5d', 3, 'f', 'JP', 'よかったです。はい、元気です。ありがとうございます。', now(), now(), '10876f18-55e1-445f-a7c0-de88491d0292','10876f18-55e1-445f-a7c0-de88491d0292'),
      ('33abe3bc-5052-487d-84b2-1b5f64677bf6', '5ea696e8-0347-42cd-ba03-d7739f12fa5d', 1, 'f', 'EN', 'Good morning.How are you?', now(), now(), '10876f18-55e1-445f-a7c0-de88491d0292','10876f18-55e1-445f-a7c0-de88491d0292'),
      ('e8fabd84-123d-4f15-aa14-071cc3e0a46f', '5ea696e8-0347-42cd-ba03-d7739f12fa5d', 2, 't', 'EN', 'Fine. Thanks. And you?', now(), now(), '10876f18-55e1-445f-a7c0-de88491d0292','10876f18-55e1-445f-a7c0-de88491d0292'),
      ('7d514541-0ca1-4ea8-9fef-3789cd3e84de', '5ea696e8-0347-42cd-ba03-d7739f12fa5d', 3, 'f', 'EN', 'Good to hear. (Im fine,thank you.)', now(), now(), '10876f18-55e1-445f-a7c0-de88491d0292','10876f18-55e1-445f-a7c0-de88491d0292');
    SQL
  end
end

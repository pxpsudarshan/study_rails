class CreateComps < ActiveRecord::Migration[7.0]
  def change
    create_table :comps, id: :uuid do |t|
      ## Database authenticatable
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.inet     :current_sign_in_ip
      t.inet     :last_sign_in_ip

      ## Confirmable
      # t.string   :confirmation_token
      # t.datetime :confirmed_at
      # t.datetime :confirmation_sent_at
      # t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      # t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      # t.string   :unlock_token # Only if unlock strategy is :email or :both
      # t.datetime :locked_at

      t.string :sei
      t.string :mei
      t.string :sei_kana
      t.string :mei_kana
      t.string :mobile

      t.string :business_type
      t.string :company_name
      t.string :company_url
      t.string :department
      t.string :company_code

      t.operator_stamps

      t.timestamps
      t.datetime :deleted_at
    end

#    add_index :comps, :email,                unique: true
    add_index :comps, :reset_password_token, unique: true
    # add_index :comps, :confirmation_token,   unique: true
    # add_index :comps, :unlock_token,         unique: true
  end
end

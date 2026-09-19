class CreateSyslogs < ActiveRecord::Migration[6.0]
  def change
    create_table :syslogs do |t|
      t.datetime :occurred_at
      t.text :context
      t.string :log_type
      t.operator_stamps

      t.timestamps
      t.datetime :deleted_at
    end
  end
end

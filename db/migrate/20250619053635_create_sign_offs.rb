class CreateSignOffs < ActiveRecord::Migration[7.1]
  def change
    create_table :sign_offs do |t|
      t.datetime :signed_at
      t.text :notes
      t.jsonb :log_entries_at_signoff
      t.references :log, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end

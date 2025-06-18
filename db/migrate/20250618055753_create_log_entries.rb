class CreateLogEntries < ActiveRecord::Migration[7.1]
  def change
    create_table :log_entries do |t|
      t.text :content
      t.integer :entry_type
      t.string :section_identifier
      t.boolean :is_editable_section
      t.references :log, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.bigint :previous_entry_id

      t.timestamps
    end
      add_foreign_key :log_entries, :log_entries, column: :previous_entry_id
      add_index :log_entries, :previous_entry_id
  end
end

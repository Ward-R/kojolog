class CreateLogs < ActiveRecord::Migration[7.1]
  def change
    create_table :logs do |t|
      t.date :date
      t.string :title
      t.integer :status
      t.references :unit, null: false, foreign_key: true

      t.timestamps
    end

    add_index :logs, [:date, :unit_id], unique: true
  end
end

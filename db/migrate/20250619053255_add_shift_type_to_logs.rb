class AddShiftTypeToLogs < ActiveRecord::Migration[7.1]
  def change
    add_column :logs, :shift_type, :string
    remove_index :logs, [:date, :unit_id]
    add_index :logs, [:date, :unit_id, :shift_type], unique: true
  end
end

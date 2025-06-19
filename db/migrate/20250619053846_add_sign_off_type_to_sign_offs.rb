class AddSignOffTypeToSignOffs < ActiveRecord::Migration[7.1]
  def change
    add_column :sign_offs, :sign_off_type, :string
    add_index :sign_offs, [:log_id, :sign_off_type], unique: true
  end
end

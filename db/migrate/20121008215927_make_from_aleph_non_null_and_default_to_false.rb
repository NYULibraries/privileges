class MakeFromAlephNonNullAndDefaultToFalse < ActiveRecord::Migration
  def up
    change_column :patron_statuses, :from_aleph, :boolean, :null => false, :default => false
    change_column :sublibraries, :from_aleph, :boolean, :null => false, :default => false
    change_column :permissions, :from_aleph, :boolean, :null => false, :default => false
    change_column :permission_values, :from_aleph, :boolean, :null => false, :default => false
    change_column :patron_status_permissions, :from_aleph, :boolean, :null => false, :default => false
  end

  def down
  end
end

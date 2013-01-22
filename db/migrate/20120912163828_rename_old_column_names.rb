class RenameOldColumnNames < ActiveRecord::Migration
  def self.up
    rename_column :patron_status_permissions, :fromAleph, :from_aleph
    rename_column :patron_status_permissions, :meta_display_status, :visible
    rename_column :patron_statuses, :fromAleph, :from_aleph
    rename_column :patron_statuses, :meta_display_status, :visible
    rename_column :permission_values, :fromAleph, :from_aleph
    rename_column :permissions, :fromAleph, :from_aleph
    rename_column :permissions, :meta_display_status, :visible
    rename_column :permissions, :display_order, :sort_order
    rename_column :sublibraries, :fromAleph, :from_aleph
    rename_column :sublibraries, :meta_display_status, :visible
  end

  def self.down
    
  end
end


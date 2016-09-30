class ChangeWebTextFields < ActiveRecord::Migration
  def up
    change_column :permission_values, :web_text, :text
  end
  def down
    change_column :permission_values, :web_text, :string
  end
end

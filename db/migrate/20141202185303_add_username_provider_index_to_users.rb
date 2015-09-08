class AddUsernameProviderIndexToUsers < ActiveRecord::Migration
  def up
    # We can do this in Privileges since we don't save any user datag
    say_with_time "Destroying All Non Admin Users" do
      User.where("user_attributes not like '%:access_grid_admin: true%'").destroy_all
    end
    add_index :users, [:username, :provider], unique: true
  end

  def down
    remove_index :users, [:username, :provider]
  end
end

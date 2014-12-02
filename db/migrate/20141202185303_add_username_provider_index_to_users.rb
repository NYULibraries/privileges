class AddUsernameProviderIndexToUsers < ActiveRecord::Migration
  def up
    # We can do this in Privileges since we don't save any user data
    say_with_time "Destroying All Non Admin Users" do
      User.non_admin.destroy_all
    end
    add_index :users, [:username, :provider], unique: true
  end

  def down
    remove_index :users, [:username, :provider]
  end
end

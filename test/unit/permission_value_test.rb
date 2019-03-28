require 'test_helper'

class PermissionValueTest < ActiveSupport::TestCase
  
  def setup
    @existing_permission_value = permission_values(:pv_aleph_one)
    @permission_value = PermissionValue.new({:web_text => "notnilwebtext", :permission_code => "multiple_hold_permission", :code => "notnilcode"})
  end

  test "code is required" do
    @permission_value.code = nil
    assert_raises(ActiveRecord::RecordInvalid) { @permission_value.save! }
    assert_not_empty(@permission_value.errors)
  end
  
  test "web text is required" do
    @permission_value.web_text = nil
    assert_raises(ActiveRecord::RecordInvalid) { @permission_value.save! }
    assert_not_empty(@permission_value.errors)
  end
  
  test "permission code is required" do
    @permission_value.permission_code = nil
    assert_raises(ActiveRecord::RecordInvalid) { @permission_value.save! }
    assert_not_empty(@permission_value.errors)
  end

  test "code is considered blank if only prefix default is passed in" do 
    @permission_value.code = "nyu_ag_noaleph_"
    assert_raises(ActiveRecord::RecordInvalid) { @permission_value.save! }
    assert_not_empty(@permission_value.errors)
  end
  
  test "belongs to permission" do
    assert @existing_permission_value.permission.is_a? Permission
    assert_equal @existing_permission_value.permission, Permission.find_by_code(@existing_permission_value.permission_code)
  end
  
  test "has many patron status permissions" do
    assert @existing_permission_value.patron_status_permissions.count > 0
    assert_equal @existing_permission_value.patron_status_permissions, PatronStatusPermission.where(:permission_value_id => @existing_permission_value.id)
  end
  
  test "has many patron statuses" do
    assert @existing_permission_value.patron_statuses.count > 0
    psps = @existing_permission_value.patron_status_permissions
    assert_equal @existing_permission_value.patron_statuses, PatronStatus.where(:code => psps.map(&:patron_status_code))
  end
  
end

require 'test_helper'

class PatronStatusPermissionTest < ActiveSupport::TestCase
  
  def setup
    @existing_psp = patron_status_permissions(:psp_aleph_one)
    @psp = PatronStatusPermission.new({:patron_status_code => 52, :sublibrary_code => "TNSGI", :permission_value_id => permission_values(:pv_aleph_one).id})
  end

  test "patron status code is required" do
    @psp.patron_status_code = nil
    assert_raises(ActiveRecord::RecordInvalid) { @psp.save! }
    assert_not_empty(@psp.errors)
  end
  
  test "permission value id is required" do
    @psp.permission_value_id = nil
    assert_raises(ActiveRecord::RecordInvalid) { @psp.save! }
    assert_not_empty(@psp.errors)
  end
  
  test "belongs to permission value" do
    assert_equal @psp.permission_value, PermissionValue.find(@psp.permission_value_id)
  end
  
  test "belongs to sublibrary" do
    assert_equal @psp.sublibrary, Sublibrary.find_by_code(@psp.sublibrary_code)
  end
  
  test "belongs to patron status" do
    assert_equal @psp.patron_status, PatronStatus.find_by_code(@psp.patron_status_code)
  end
  
  test "has one permission" do
    assert_equal @psp.permission, Permission.find_by_code(@psp.permission_value.permission_code)
  end
    
end

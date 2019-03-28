require 'test_helper'

class PermissionTest < ActiveSupport::TestCase
  
    def setup
      @existing_permission = permissions(:aleph_one)
      @permission = Permission.new
    end

    test "code is unique" do
      @permission.code = @existing_permission.code
      assert_raises(ActiveRecord::RecordInvalid) { @permission.save! }
      assert_not_empty(@permission.errors)
    end

    test "web text is required if not from aleph" do
      @permission.code = "nonexistentcodeasofyet"
      @permission.from_aleph = false
      assert_raises(ActiveRecord::RecordInvalid) { @permission.save! }
      assert_not_empty(@permission.errors)
    end

    test "code is considered blank if only prefix default is passed in" do 
      @permission.code = "nyu_ag_noaleph_"
      assert_raises(ActiveRecord::RecordInvalid) { @permission.save! }
      assert_not_empty(@permission.errors)
    end
    
    test "has many permission values" do
      assert @existing_permission.permission_values.count > 0
      assert_equal @existing_permission.permission_values.sort, PermissionValue.where(:permission_code => @existing_permission.code).sort
    end
    
    test "has many patron status permissions" do
      assert @existing_permission.patron_status_permissions.count > 0
      assert_equal @existing_permission.patron_status_permissions.sort, PatronStatusPermission.where(:permission_value_id => PermissionValue.where(:permission_code => @existing_permission.code)).sort
    end
    
    test "has many patron statuses" do
      assert @existing_permission.patron_statuses.count > 0      
      psps = PatronStatusPermission.where(:permission_value_id => PermissionValue.where(:permission_code => @existing_permission.code))
      assert_equal @existing_permission.patron_statuses.uniq.sort, PatronStatus.where(:code => psps.map(&:patron_status_code)).sort
    end

end

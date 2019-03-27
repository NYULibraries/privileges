require 'test_helper'

class SublibraryTest < ActiveSupport::TestCase
  

  def setup
    @existing_sublibrary = sublibraries(:aleph_one)
    @sublibrary = Sublibrary.new
  end
  
  test "visible scope returns only visible" do
    @sublibraries = Sublibrary.visible
    @sublibraries.each do |sublibrary|
      assert_not_equal sublibrary.code, "nyu_ag_noaleph_general"
      assert_not_nil sublibrary.web_text
      assert_not_equal sublibrary.web_text, ""
      assert sublibrary.visible
    end
  end
  
  test "code is unique" do
    @sublibrary.code = @existing_sublibrary.code
    assert_raises(ActiveRecord::RecordInvalid) { @sublibrary.save! }
    assert_not_empty(@sublibrary.errors)
  end
  
  test "web text is required if not from aleph" do
    @sublibrary.code = "nonexistentcodeasofyet"
    @sublibrary.from_aleph = false
    assert_raises(ActiveRecord::RecordInvalid) { @sublibrary.save! }
    assert_not_empty(@sublibrary.errors)
  end
  
  test "code is considered blank if only prefix default is passed in" do 
    @sublibrary.code = "nyu_ag_noaleph_"
    assert_raises(ActiveRecord::RecordInvalid) { @sublibrary.save! }
    assert_not_empty(@sublibrary.errors)
  end

  test "has many patron status permissions" do
    assert @existing_sublibrary.patron_status_permissions.count > 0
    assert_equal @existing_sublibrary.patron_status_permissions, PatronStatusPermission.where(sublibrary_code: @existing_sublibrary.code)
  end

end

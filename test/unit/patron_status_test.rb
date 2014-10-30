require 'test_helper'

class PatronStatusTest < ActiveSupport::TestCase

  def setup
    @existing_patron_status = patron_statuses(:aleph_one)
    @patron_status = PatronStatus.new
  end

  test "code is unique" do
    @patron_status.code = @existing_patron_status.code
    assert_raises(ActiveRecord::RecordInvalid) { @patron_status.save! }
    assert_not_empty(@patron_status.errors)
  end

  test "web text is required if not from aleph" do
    @patron_status.code = "nonexistentcodeasofyet"
    @patron_status.from_aleph = false
    assert_raises(ActiveRecord::RecordInvalid) { @patron_status.save! }
    assert_not_empty(@patron_status.errors)
  end

  test "code is considered blank if only prefix default is passed in" do
    @patron_status.code = "nyu_ag_noaleph_"
    assert_raises(ActiveRecord::RecordInvalid) { @patron_status.save! }
    assert_not_empty(@patron_status.errors)
  end

  test "has many patron status permissions" do
    assert @existing_patron_status.patron_status_permissions.count > 0
    assert_equal @existing_patron_status.patron_status_permissions, PatronStatusPermission.where(patron_status_code: @existing_patron_status.code)
  end

  test "has many sublibraries" do
    assert @existing_patron_status.sublibraries.count > 0
  end

  test "has many permissions" do
    assert @existing_patron_status.permissions.count > 0
  end

end

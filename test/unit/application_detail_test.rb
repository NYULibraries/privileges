require 'test_helper'

class ApplicationDetailTest < ActiveSupport::TestCase
 
 test "detail without description is invalid" do
   app_detail = ApplicationDetail.new({purpose: "testing_purposes", the_text: "my test text", description: nil})
   assert app_detail.invalid?
 end
 
 test "detail without purpose is invalid" do 
   app_detail = ApplicationDetail.new({purpose: nil, the_text: "my test text", description: "a real description of this detail"})
   assert app_detail.invalid?
 end
 
 test "detail without any text is invalid" do 
   app_detail = ApplicationDetail.new({purpose: "testing_purposes", the_text: nil, description: "a real description of this detail"})
   assert app_detail.invalid?
 end
 
 test "check purpose is unique" do
   app_detail = ApplicationDetail.new({purpose: application_details(:one).purpose, description: "a real description of this detail"})
   assert app_detail.invalid?
 end
 
end

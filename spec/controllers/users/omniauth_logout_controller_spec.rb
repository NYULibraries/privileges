require 'rails_helper'
describe Users::OmniauthLogoutController do

  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in create(:user)
  end

  describe "DELETE /sso_logout" do
    before { delete :sso_logout }
    subject { response }
    context "when"
    it "should return a 200 status" do
      expect(subject.status).to be 200
    end
    it "should log the user out" do
      expect(controller.current_user).to be_nil
    end
  end
end

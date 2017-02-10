require 'rails_helper'
describe User do
  subject { create(:user) }
  it { should be_a User }

  describe 'scopes' do
    before do
      create(:user)
      create(:admin)
    end
    describe 'non_admin' do
      subject { User.non_admin.count }
      it { is_expected.to eql 1 }
    end
    describe 'admin' do
      subject { User.admin.count }
      it { is_expected.to eql 1 }
    end
    describe 'inactive' do
      subject { User.inactive.count }
      it { is_expected.to eql 0 }
    end
  end
end

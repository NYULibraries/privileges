require 'rails_helper'
describe User do
  subject { create(:user) }
  it { should be_a User }
end

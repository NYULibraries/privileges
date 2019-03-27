require 'rails_helper'

describe PermissionValuesController do
  let(:web_text) { 'A short trying describing this permission value' }
  let!(:permission) { create(:permission) }
  let(:permission_value) { attributes_for(:permission_value, web_text: web_text, permission_code: permission.code)}

  before do
    request.env['devise.mapping'] = Devise.mappings[:user]
    sign_in create(:admin)
  end

  describe '#create' do
    before { post :create, params: { permission_value: permission_value } }
    subject { response }
    context 'when web_text is a short string' do
      it 'should create a permission value' do
        expect(assigns(:permission_value)).to be_a(PermissionValue)
      end
    end
    context 'when web_text is a very long paragraph' do
      let(:web_text) { 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer metus sapien, finibus vitae felis vitae, vestibulum pretium nisi. Fusce semper venenatis volutpat. In lobortis augue in neque euismod ullamcorper. Suspendisse potenti. Aliquam erat volutpat. In sit amet elit urna. Nullam tempus dui efficitur nulla condimentum, in posuere sem faucibus. Aenean neque nisi, pretium in luctus et, ullamcorper in nunc. Quisque a posuere neque. Ut quis justo ac tortor pharetra pharetra. Interdum et malesuada fames ac ante ipsum primis in faucibus. Morbi rutrum, justo ut tempor porttitor, elit erat tempus orci, quis lobortis tortor odio porttitor velit. Proin elementum mi a sem dapibus commodo. Morbi hendrerit quis nisi at aliquam.' }
      it 'should create a permission value' do
        expect(assigns(:permission_value)).to be_a(PermissionValue)
      end
    end
  end
end

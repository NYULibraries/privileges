require 'rails_helper'

describe PrivilegesController do

  before do
    request.env['devise.mapping'] = Devise.mappings[:user]
  end

  describe '#index_patron_statuses' do
    subject { response }

    context "when unauthenticated" do
      before { get :index_patron_statuses }

      it { is_expected.to render_template "index_patron_statuses" }
      it "should setup search" do
        expect(assigns(:patron_status_search)).to be_a(Privileges::Search::PatronStatusSearch)
      end
    end

    context "when user signed in" do
      let(:user){ create(:user, patron_status: '23') }
      let(:patron_status){ create(:patron_status, code: user.patron_status) }
      let(:redirect_path){ patron_path("#{patron_status.id}-#{@controller.send(:urlize, patron_status.web_text)}") }
      before do
        sign_in user
        get :index_patron_statuses
      end
      subject { response }

      it { is_expected.to redirect_to redirect_path }
      it "should assign patron_status" do
        expect(user.patron_status).to eq patron_status.code
        expect(assigns(:patron_status).stored(:code)).to eq user.patron_status
      end
    end
  end

  describe '#show_patron_status' do
    let(:patron_status) { create(:patron_status) }
    before { get :show_patron_status, params: { id: patron_status.id, sublibrary_code: sublibrary_code } }

    subject { response }
    context 'when there is no sublibrary code' do
      let(:sublibrary_code) { nil }
      it 'should set up variables' do
        expect(assigns(:patron_status)).to eql patron_status
        expect(assigns(:sublibraries)).to_not be_nil
        expect(assigns(:sublibrary)).to be_nil
        expect(subject).to render_template(:show_patron_status)
      end
    end
    context 'when there is a sublibrary code provided' do
      let(:sublibrary) { create(:sublibrary) }
      let(:sublibrary_code) { sublibrary.code }
      it 'should set up variables' do
        expect(assigns(:patron_status_permissions)).to_not be_nil
        expect(assigns(:sublibrary)).to eql sublibrary
        expect(subject).to render_template(:show_patron_status)
      end
    end

    # test "show individual patron status" do
    #   get :show_patron_status, :id => patron_statuses(:aleph_one)
    #   assert assigns(:patron_status)
    #   assert assigns(:sublibraries_with_access)
    #   assert assigns(:sublibraries)
    #   assert !assigns(:sublibrary)
    #
    #   assert_template "show_patron_status"
    # end
    #
    # test "show individual patron status with sublibrary permissions" do
    #   get :show_patron_status, :id => patron_statuses(:aleph_one), :sublibrary_code => sublibraries(:aleph_one).code
    #   assert assigns(:sublibrary)
    #   assert assigns(:patron_status_permissions)
    #
    #   assert_template "show_patron_status"
    # end
  end

  describe '#search' do

  end

end

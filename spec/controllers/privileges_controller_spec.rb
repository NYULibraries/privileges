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
      let(:user){ create(:user) }
      let!(:patron_status){ create(:patron_status, code: user.patron_status) }
      let(:redirect_path){ patron_path("#{patron_status.id}-#{@controller.send(:urlize, patron_status.web_text)}") }
      before do
        sign_in user
        get :index_patron_statuses
      end

      it { is_expected.to redirect_to redirect_path }
      it "should assign patron_status" do
        expect(user.patron_status).to eq patron_status.code
        expect(assigns(:patron_status).stored(:code)).to eq user.patron_status
      end
    end
  end

end

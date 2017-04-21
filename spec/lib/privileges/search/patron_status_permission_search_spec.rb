require 'rails_helper'

describe Privileges::Search::PatronStatusPermissionSearch do
  let(:search){ described_class.new(**options) }
  let(:options){ {} }

  describe "sublibrary_permissions" do
    subject{ search.sublibrary_permissions }
    
    context "with sublibrary_code" do
      let(:options){ {sublibrary_code: "abcd"} }

      before { allow(search).to receive(:hits).and_return hits }
      context "with hits" do
        let(:hits){ [instance_double(Sunspot::Search::Hit, to_param: "10"), instance_double(Sunspot::Search::Hit, to_param: "12")] }

        it { is_expected.to be_a ActiveRecord::Relation }
        its(:where_values_hash){ is_expected.to eq({"id" => ["10", "12"]}) }
        its(:values){ is_expected.to include({
          select: ["patron_status_permissions.*, permissions.web_text as permission_web_text, permission_values.web_text as permission_value_web_text"],
          joins: [{:permission_value=>:permission}],
          references: ["permissions"],
          bind: [],
        }) }
      end

      context "without hits" do
        let(:hits){ [] }

        it { is_expected.to be_a ActiveRecord::Relation }
        its(:where_values_hash){ is_expected.to eq({"id" => []}) }
        its(:values){ is_expected.to include({
          select: ["patron_status_permissions.*, permissions.web_text as permission_web_text, permission_values.web_text as permission_value_web_text"],
          joins: [{:permission_value=>:permission}],
          references: ["permissions"],
          bind: [],
        }) }
      end
    end

    context "without sublibrary_code" do
      it { is_expected.to eq nil }
    end
  end

  describe "hits" do
    subject{ search.hits }
    let(:solr_search){ instance_double Sunspot::Search::StandardSearch, hits: hits }
    let(:hits){ instance_double Sunspot::Search::PaginatedCollection }
    before { allow(search).to receive(:solr_search).and_return solr_search }

    it { is_expected.to eq hits }
  end

  describe "solr_search" do
    subject{ search.solr_search }
    let(:search_params){ subject.query.to_params }
    let(:default_params) do
      ({
        :fq=>["type:PatronStatusPermission", "-patron_status_code_ss:[* TO *]", "-sublibrary_code_ss:[* TO *]", "permission_visible_bs:true", "visible_bs:true"],
        :start=>0,
        :rows=>200,
        :q=>"*:*"
      })
    end

    context "with defaults" do
      it { is_expected.to be_a Sunspot::Search::StandardSearch }
      it "has correct params" do
        expect(search_params).to eq default_params
      end
    end

    context "with admin_view" do
      let(:options){ {admin_view: true} }
      let(:admin_params) do
        default_params.merge({
          :fq=>["type:PatronStatusPermission", "-patron_status_code_ss:[* TO *]", "-sublibrary_code_ss:[* TO *]", "permission_visible_bs:true"],
        })
      end
      it { is_expected.to be_a Sunspot::Search::StandardSearch }
      it "has correct params" do
        expect(search_params).to eq admin_params
      end
    end

    context "without admin view" do
      context "with patron_status_code" do
        let(:options){ {patron_status_code: "abcd"} }
        let(:patron_status_params) do
          default_params.merge({
            :fq=>["type:PatronStatusPermission", "patron_status_code_ss:abcd", "-sublibrary_code_ss:[* TO *]", "permission_visible_bs:true", "visible_bs:true"]
          })
        end

        it { is_expected.to be_a Sunspot::Search::StandardSearch }
        it "has correct params" do
          expect(search_params).to eq patron_status_params
        end
      end

      context "with sublibrary_code" do
        let(:options){ {sublibrary_code: "abcd"} }
        let(:sublibrary_params) do
          default_params.merge({
            :fq=>["type:PatronStatusPermission", "-patron_status_code_ss:[* TO *]", "sublibrary_code_ss:abcd", "permission_visible_bs:true", "visible_bs:true"]
          })
        end

        it { is_expected.to be_a Sunspot::Search::StandardSearch }
        it "has correct params" do
          expect(search_params).to eq sublibrary_params
        end
      end
    end
  end
end

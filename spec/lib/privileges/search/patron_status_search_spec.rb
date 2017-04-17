require 'rails_helper'

describe Privileges::Search::PatronStatusSearch do
  let(:search){ described_class.new(**options) }
  let(:options){ {} }

  describe "self.new_from_params" do
    let(:params){ ActionController::Parameters.new(params_hash) }

    context "given just params" do
      subject{ described_class.new_from_params(params) }

      context "with nonempty values" do
        let(:params_hash){ {q: "some text", sort: "original_text", direction: "desc", sublibrary_code: "abcd", patron_status_code: "wxyz", page: 4, admin_view: true} }

        it { is_expected.to be_a described_class }
        its(:q){ is_expected.to eq "some text" }
        its(:sort){ is_expected.to eq "original_text" }
        its(:direction){ is_expected.to eq "desc" }
        its(:page){ is_expected.to eq 4 }
        its(:sublibrary_code){ is_expected.to eq "abcd" }
        its(:patron_status_code){ is_expected.to eq "wxyz" }
        # don't assign admin_view from params
        its(:admin_view){ is_expected.to eq false }
      end

      context "with empty values" do
        let(:params_hash){ {q: "", sort: "", direction: "", page: "", sublibrary_code: "", patron_status_code: "", admin_view: ""} }

        it { is_expected.to be_a described_class }
        its(:q){ is_expected.to eq nil }
        its(:sort){ is_expected.to eq nil }
        its(:direction){ is_expected.to eq :asc }
        its(:page){ is_expected.to eq 1 }
        its(:sublibrary_code){ is_expected.to eq nil }
        its(:patron_status_code){ is_expected.to eq nil }
        its(:admin_view){ is_expected.to eq false }
      end

      context "when empty" do
        let(:params_hash){ {} }

        it { is_expected.to be_a described_class }
        its(:q){ is_expected.to eq nil }
        its(:sort){ is_expected.to eq nil }
        its(:direction){ is_expected.to eq :asc }
        its(:page){ is_expected.to eq 1 }
        its(:sublibrary_code){ is_expected.to eq nil }
        its(:patron_status_code){ is_expected.to eq nil }
        its(:admin_view){ is_expected.to eq false }
      end
    end

    context "given params and options" do
      subject{ described_class.new_from_params(params, **options) }
      let(:params_hash){ {q: "some text", sort: "original_text", direction: "desc", page: 4, sublibrary_code: "abcd", patron_status_code: "wxyz"} }
      let(:options){ {admin_view: true} }

      it { is_expected.to be_a described_class }
      its(:q){ is_expected.to eq "some text" }
      its(:sort){ is_expected.to eq "original_text" }
      its(:direction){ is_expected.to eq "desc" }
      its(:page){ is_expected.to eq 4 }
      its(:sublibrary_code){ is_expected.to eq "abcd" }
      its(:patron_status_code){ is_expected.to eq "wxyz" }
      its(:admin_view){ is_expected.to eq true }
    end
  end

  describe "results" do
    subject{ search.results }
    let(:solr_search){ instance_double Sunspot::Search::StandardSearch, results: results }
    let(:results){ instance_double Sunspot::Search::PaginatedCollection }
    before { allow(search).to receive(:solr_search).and_return solr_search }

    it { is_expected.to eq results }
  end

  describe "hits" do
    subject{ search.hits }
    let(:solr_search){ instance_double Sunspot::Search::StandardSearch, hits: hits }
    let(:hits){ instance_double Sunspot::Search::PaginatedCollection }
    before { allow(search).to receive(:solr_search).and_return solr_search }

    it { is_expected.to eq hits }
  end

  describe "sublibraries_with_access" do
    subject{ search.sublibraries_with_access }
    let(:hit){ instance_double Sunspot::Search::Hit }
    let(:hits){ instance_double Sunspot::Search::PaginatedCollection, first: hit }
    let(:stored_sublibraries_with_access){ ["NIFA", "NCOUR", "TNSSC"] }
    before do
      allow(search).to receive(:hits).and_return hits
      allow(hit).to receive(:stored).with(:sublibraries_with_access).and_return stored_sublibraries_with_access
    end

    it { is_expected.to eq stored_sublibraries_with_access }
  end

  describe "solr_search" do
    subject{ search.solr_search }
    let(:search_params){ subject.query.to_params }
    let(:default_params) do
      ({
        :fq=>["type:PatronStatus", "web_text_ss:[* TO *]", "visible_bs:true"],
        :sort=>"sort_header_ss asc, web_text_ss asc",
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
        ({
          :fq=>["type:PatronStatus", "web_text_ss:[* TO *]"],
          :sort=>"sort_header_ss asc, web_text_ss asc",
          :start=>0,
          :rows=>30,
          :q=>"*:*"
        })
      end
      it { is_expected.to be_a Sunspot::Search::StandardSearch }
      it "has correct params" do
        expect(search_params).to eq admin_params
      end

      context "with page" do
        let(:options){ {page: 3, admin_view: true} }
        let(:admin_page_params) do
          admin_params.merge({
            :start=>60,
          })
        end
        it { is_expected.to be_a Sunspot::Search::StandardSearch }
        it "has correct params" do
          expect(search_params).to eq admin_page_params
        end
      end

      context "with sort" do
        let(:options){ {sort: "code", direction: "desc", admin_view: true} }
        let(:admin_page_params) do
          admin_params.merge({
            :sort=>"code_ss desc",
          })
        end
        it { is_expected.to be_a Sunspot::Search::StandardSearch }
        it "has correct params" do
          expect(search_params).to eq admin_page_params
        end
      end

      context "with query" do
        let(:options){ {q: "some text", admin_view: true} }
        let(:admin_query_params) do
          admin_params.merge({
            :defType=>"edismax",
            :fl=>"* score",
            :q=>"some text",
            :qf=>"keywords_text web_text_text code_text description_text under_header_text original_text_text",
          })
        end
        it { is_expected.to be_a Sunspot::Search::StandardSearch }
        it "has correct params" do
          expect(search_params).to eq admin_query_params
        end

        context "with page" do
          let(:options){ {q: "some text", page: 2, admin_view: true} }
          let(:admin_query_page_params) do
            admin_query_params.merge({
              :start=>30,
            })
          end
          it { is_expected.to be_a Sunspot::Search::StandardSearch }
          it "has correct params" do
            expect(search_params).to eq admin_query_page_params
          end
        end
      end # end "with query"
    end # end "with admin_view"

    context "without admin_view" do
      context "with query" do
        let(:options){ {q: "some text"} }
        let(:query_params) do
          default_params.merge({
            :defType=>"edismax",
            :fl=>"* score",
            :q=>"some text",
            :qf=>"keywords_text web_text_text code_text",
          })
        end
        it { is_expected.to be_a Sunspot::Search::StandardSearch }
        it "has correct params" do
          expect(search_params).to eq query_params
        end
      end

      describe "with sublibrary_code" do
        let(:options){ {sublibrary_code: "abcd"} }
        let(:sublibrary_params) do
          default_params.merge({
            :fq=>["type:PatronStatus", "web_text_ss:[* TO *]", "visible_bs:true", "sublibraries_with_access_sms:abcd"]
          })
        end

        it { is_expected.to be_a Sunspot::Search::StandardSearch }
        it "has correct params" do
          expect(search_params).to eq sublibrary_params
        end
      end

      describe "with patron_status_code" do
        let(:options){ {patron_status_code: "wxyz"} }
        let(:patron_status_params) do
          default_params.merge({
            :fq=>["type:PatronStatus", "web_text_ss:[* TO *]", "visible_bs:true", "code_ss:wxyz"]
          })
        end

        it { is_expected.to be_a Sunspot::Search::StandardSearch }
        it "has correct params" do
          expect(search_params).to eq patron_status_params
        end
      end
    end # end "without admin_view"
  end # end "solr_search"
end

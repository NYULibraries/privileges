require 'rails_helper'

describe Privileges::Search::PatronStatusSearch do
  let(:search){ described_class.new(**options) }
  let(:options){ {} }

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
        fq: ["type:PatronStatus", "web_text_ss:[* TO *]", "visible_bs:true"],
        sort: "sort_header_ss asc, web_text_ss asc",
        start: 0,
        rows: 200,
        q: "*:*"
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
          fq: ["type:PatronStatus", "web_text_ss:[* TO *]"],
          sort: "sort_header_ss asc, web_text_ss asc",
          start: 0,
          rows: 30,
          q: "*:*"
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
            start: 60,
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
            sort: "code_ss desc",
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
            defType: "edismax",
            fl: "* score",
            q: "some text",
            qf: "keywords_text web_text_text code_text description_text under_header_text original_text_text",
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
              start: 30,
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
            defType: "edismax",
            fl: "* score",
            q: "some text",
            qf: "keywords_text web_text_text code_text",
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
            fq: ["type:PatronStatus", "web_text_ss:[* TO *]", "visible_bs:true", "sublibraries_with_access_sms:abcd"]
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
            fq: ["type:PatronStatus", "web_text_ss:[* TO *]", "visible_bs:true", "code_ss:wxyz"]
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

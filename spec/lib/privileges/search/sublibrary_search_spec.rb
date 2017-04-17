require 'rails_helper'

describe Privileges::Search::SublibrarySearch do
  let(:search){ Privileges::Search::SublibrarySearch.new(**options) }
  let(:options){ {} }

  describe "self.new_from_params" do
    let(:params){ ActionController::Parameters.new(params_hash) }

    context "given just params" do
      subject{ described_class.new_from_params(params) }

      context "with nonempty values" do
        let(:params_hash){ {q: "some text", sort: "original_text", direction: "desc", page: 4, admin_view: true} }

        it { is_expected.to be_a described_class }
        its(:q){ is_expected.to eq "some text" }
        its(:sort){ is_expected.to eq "original_text" }
        its(:direction){ is_expected.to eq "desc" }
        its(:page){ is_expected.to eq 4 }
        # don't assign admin_view from params
        its(:admin_view){ is_expected.to eq false }
      end

      context "with empty values" do
        let(:params_hash){ {q: "", sort: "", direction: "", page: "", admin_view: ""} }

        it { is_expected.to be_a described_class }
        its(:q){ is_expected.to eq nil }
        its(:sort){ is_expected.to eq nil }
        its(:direction){ is_expected.to eq :asc }
        its(:page){ is_expected.to eq 1 }
        its(:admin_view){ is_expected.to eq false }
      end

      context "when empty" do
        let(:params_hash){ {} }

        it { is_expected.to be_a described_class }
        its(:q){ is_expected.to eq nil }
        its(:sort){ is_expected.to eq nil }
        its(:direction){ is_expected.to eq :asc }
        its(:page){ is_expected.to eq 1 }
        its(:admin_view){ is_expected.to eq false }
      end
    end

    context "given params and options" do
      subject{ described_class.new_from_params(params, **options) }
      let(:params_hash){ {q: "some text", sort: "original_text", direction: "desc", page: 4} }
      let(:options){ {admin_view: true} }

      it { is_expected.to be_a described_class }
      its(:q){ is_expected.to eq "some text" }
      its(:sort){ is_expected.to eq "original_text" }
      its(:direction){ is_expected.to eq "desc" }
      its(:page){ is_expected.to eq 4 }
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

  describe "solr_search" do
    subject{ search.solr_search }
    let(:search_params){ subject.query.to_params }
    let(:default_params) do
      ({
        :fq=>["type:Sublibrary", "visible_frontend_bs:true"],
        :sort=>"sort_header_ss asc, sort_text_ss asc",
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
          :fq=>["type:Sublibrary"],
          :sort=>"sort_header_ss asc, sort_text_ss asc",
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
        let(:options){ {page: 2, admin_view: true} }
        let(:admin_page_params) do
          admin_params.merge({
            :start=>30,
          })
        end
        it { is_expected.to be_a Sunspot::Search::StandardSearch }
        it "has correct params" do
          expect(search_params).to eq admin_page_params
        end
      end

      context "with sort" do
        let(:options){ {sort: "sort_text", direction: "desc", admin_view: true} }
        let(:admin_page_params) do
          admin_params.merge({
            :sort=>"sort_text_ss desc",
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
            :qf=>"web_text_text original_text_text code_text under_header_text",
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
  end # end describe "search"

end

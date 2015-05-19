# User factory
FactoryGirl.define do
  factory :patron_status do
    code "51"
    original_text "Admiwwedqs"
    web_text "Administrator"
    from_aleph true
    visible true
    description "Something here"
    id_type "You need an ID fool"
    under_header "All things must pass"
    keywords "Shall, Not, Pass"
  end
end
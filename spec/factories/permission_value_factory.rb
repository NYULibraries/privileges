FactoryBot.define do
  factory :permission_value do
    permission_code 'nyu_ag_noaleph_dummy_permission'
    code 'nyu_ag_noaleph_dummy_permission_value'
    from_aleph false
    web_text 'Click here to make a <a href="/">request.</a>'
  end
end

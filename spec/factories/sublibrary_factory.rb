FactoryBot.define do
  factory :sublibrary do
    code 'TNSFO'
    original_text 'New School Fogelman Library'
    web_text 'New School Fogelman Library'
    from_aleph true
    visible true
    under_header 'New School'

    after(:create) do |sublibrary|
      sublibrary.index!
    end
  end
end

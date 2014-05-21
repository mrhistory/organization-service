FactoryGirl.define do
  factory :organization do
    name 'Fake Organization'
    address1 '123 Main St.'
    city 'Lawrenceville'
    state 'GA'
    zipcode '30044'
    phone_number '1234567890'
    applications []
  end

  factory :application do
    name 'Fake App'
    url 'https://road-to-nowhere.com'
  end
end
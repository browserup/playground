FactoryBot.define do
  factory :toy do
    name { "Car #{rand(999999999)}" }
    description {'A toy car'}
  end
end

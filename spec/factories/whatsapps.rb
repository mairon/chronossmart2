FactoryBot.define do
  factory :whatsapp do
    instance { Faker::Internet.uuid }
    token { Faker::Internet.uuid }
  end

  trait :free do
    status { 0 }
  end

  trait :occupied do
    status { 1 }
  end
end

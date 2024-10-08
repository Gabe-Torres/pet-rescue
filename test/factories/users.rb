FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { "123456" }
    encrypted_password { Devise::Encryptor.digest(User, "123456") }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    tos_agreement { true }

    trait :with_avatar do
      after(:build) do |user|
        user.avatar.attach(
          io: File.open(Rails.root.join("test", "fixtures", "files", "test.png")),
          filename: "test.png",
          content_type: "image/png"
        )
      end
    end

    factory :adopter do
      adopter_foster_account do
        association :adopter_foster_account, user: instance
      end

      after(:build) do |user, _context|
        user.add_role(:adopter, user.organization)
      end
    end

    factory :fosterer do
      adopter_foster_account do
        association :adopter_foster_account, user: instance
      end

      after(:build) do |user, _context|
        user.add_role(:fosterer, user.organization)
        user.add_role(:adopter, user.organization)
      end
    end

    factory :admin do
      staff_account do
        association :staff_account, user: instance
      end

      trait :deactivated do
        staff_account do
          association :staff_account, :deactivated, user: instance
        end
      end

      after(:build) do |user, _context|
        user.add_role(:admin, user.organization)
      end
    end

    factory :super_admin do
      staff_account do
        association :staff_account, user: instance
      end

      after(:build) do |user, _context|
        user.add_role(:super_admin, user.organization)
      end
    end
  end
end

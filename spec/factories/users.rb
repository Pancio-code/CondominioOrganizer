FactoryBot.define do
    factory :user do
        uname {'test'}
        factory :email do
            email {'test@example.com'}
        end
        factory :email1 do
            email {'test1@example.com'}
        end
        password {'Test1234@'}

    end
end
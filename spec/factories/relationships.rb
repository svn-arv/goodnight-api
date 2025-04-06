FactoryBot.define do
  factory :relationship do
    user { association(:user) }
    following { association(:user) }
  end
end

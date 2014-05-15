FactoryGirl.define do
  factory :language do
    type :C

    trait :with_cpp_type do
      type :CPP
    end

    trait :with_java_type do
      type :JAVA
    end

    factory :language_cpp, traits: [:with_cpp_type]
    factory :language_java, traits: [:with_java_type]

    initialize_with { Language.new(type) }
  end
end

FactoryGirl.define  do
  factory :kalibro_gatekeeper_client_metric, class: KalibroGatekeeperClient::Entities::Metric do
    compound false
    name "Total Abstract Classes"
    scope { FactoryGirl.build(:granularity) }
    description "Total Abstract Classes"

    trait :compound do
      compound true
    end

    trait :loc do
      name "Lines of Code"
      scope "CLASS"
      description nil
      language ["C", "CPP", "JAVA"]
    end

    factory :kalibro_gatekeeper_client_compound_metric, traits: [:compound]

    factory :kalibro_gatekeeper_client_loc, traits: [:loc]
  end
end
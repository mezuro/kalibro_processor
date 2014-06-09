FactoryGirl.define  do
  factory :kalibro_gatekeeper_client_metric, class: KalibroGatekeeperClient::Entities::Metric do
    compound false
    name "Total Abstract Classes"
    scope { FactoryGirl.build(:granularity) }
    description "Total Abstract Classes"
  end
end
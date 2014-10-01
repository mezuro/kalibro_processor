FactoryGirl.define do
  factory :context, class: Processor::Context do
    repository { FactoryGirl.build(:repository) }
    processing { FactoryGirl.build(:processing) }
  end
end
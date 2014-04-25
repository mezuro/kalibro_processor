FactoryGirl.define do
  factory :module_result do
    kalibro_module { FactoryGirl.build(:kalibro_module) }
    parent nil
    grade "10.0"

    initialize_with { ModuleResult.new(parent, kalibro_module) } 
  end

end

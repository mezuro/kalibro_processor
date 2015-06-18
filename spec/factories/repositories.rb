# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :repository do
    name "QtCalculator"
    scm_type "SUBVERSION"
    address "svn://svn.code.sf.net/p/qt-calculator/code/trunk"
    branch "master"
    description "An easy calculator"
    license "None"
    period 0

    trait :sbking do
      name "SBKing"
      scm_type "GIT"
      address "https://github.com/rafamanzo/runge-kutta-vtk.git"
      description "SBKing"
    end

    trait :ruby do
      name "KalibroProcessor"
      scm_type "GIT"
      address "https://github.com/mezuro/kalibro_processor"
      description "Kalibro Processor"
    end

    trait :python do
      name "Busineme"
      scm_type "GIT"
      address "https://github.com/Busineme/BusinemeWeb"
      description "BusinemeWeb"
    end

    trait :another_branch do
      branch "dev"
    end

    trait :with_project_id do
      project { FactoryGirl.build(:project_with_id) }
    end

    factory :sbking_repository, traits: [:sbking]
    factory :ruby_repository, traits: [:ruby]
    factory :python_repository, traits: [:python]
    factory :custom_branch, traits: [:another_branch]
  end
end

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

    trait :kalibro_processor do
      name "KalibroProcessor"
      scm_type "GIT"
      address "https://github.com/mezuro/kalibro_processor"
      description "Kalibro Processor"
    end

    trait :noosfero do
      name "Noosfero"
      scm_type "GIT"
      address "https://gitlab.com/noosfero/noosfero.git"
      description "Noosfero - a web-based social platform"
    end

    trait :arquigrafia do
      name "Arquigrafia"
      scm_type "GIT"
      address "https://github.com/anapaula/Arquigrafia-Laravel.git"
      description "Arquigrafia"
    end

    trait :ruby do
      kalibro_processor
    end

    trait :python do
      name "KalibroClient"
      scm_type "GIT"
      address "https://github.com/mezuro/kalibro_client_py"
      description "Python version for KalibroClient"
    end

    trait :php do
      arquigrafia
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
    factory :php_repository, traits: [:php]
    factory :custom_branch, traits: [:another_branch]
  end
end

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :repository do
    name "QtCalculator"
    scm_type "SUBVERSION"
    address "svn://svn.code.sf.net/p/qt-calculator/code/trunk"
    description "An easy calculator"
    license "None"
    period 0
    configuration { FactoryGirl.build(:configuration) }
  end
end

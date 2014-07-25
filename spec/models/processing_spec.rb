require 'rails_helper'

RSpec.describe Processing, :type => :model do
  describe 'associations' do
    it {is_expected.to belong_to(:repository)}
    it {is_expected.to belong_to(:root_module_result).
      with_foreign_key('root_module_result_id').
      class_name('ModuleResult')
    }
    it {is_expected.to have_many(:process_times).dependent(:destroy)}
    it {is_expected.to have_many(:module_results).dependent(:destroy)}
  end
end
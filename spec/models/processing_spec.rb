require 'rails_helper'

RSpec.describe Processing, :type => :model do
  describe 'associations' do
    it {is_expected.to belong_to(:repository)}
    it {is_expected.to belong_to(:root_module_result).
      with_foreign_key('root_module_result_id').
      class_name('ModuleResult')
    }
    it {is_expected.to have_many(:process_times)}
    it {is_expected.to have_many(:module_results)}
  end

  describe 'methods' do
    describe 'find_by_repository_and_date' do
      let(:date) {"2011-10-20T18:26:43.151+00:00"}
      let(:order) { ">=" }
      let(:repository) { FactoryGirl.build(:repository) }
      let(:repository_processings) {mock("repository_processings")}
      it 'is expected to return a processing' do
        Processing.expects(:where).with(repository: repository).returns(repository_processings)
        repository_processings.expects(:where).with("updated_at >= :date", {date: date}).returns([subject])
        expect(Processing.find_by_repository_and_date(repository, date, order)).to eq([subject])
      end
    end

    describe 'find_ready_by_repository' do
      let(:repository) { FactoryGirl.build(:repository) }

      it 'is expected to return a processing' do
        Processing.expects(:where).with(repository: repository, state: "READY").returns([subject])

        expect(Processing.find_ready_by_repository(repository)).to eq([subject])
      end
    end
  end
end
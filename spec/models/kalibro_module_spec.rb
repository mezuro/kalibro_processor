require 'rails_helper'

describe KalibroModule, :type => :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:module_result) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:module_result) }
  end

  describe 'method' do
    describe 'short_name' do
      subject { FactoryGirl.build(:kalibro_module) }

      it 'should get the last element of the name' do
        expect(subject.short_name).to eq(subject.name.last)
      end
    end

    describe 'long_name' do
      subject { FactoryGirl.build(:kalibro_module) }

      it 'should get the join the name' do
        expect(subject.long_name).to eq(subject.name.join('.'))
      end
    end

    describe 'to_s' do
      subject { FactoryGirl.build(:kalibro_module) }

      it 'should be a alias to short_name' do
        subject.expects(:short_name).returns('short_name')

        subject.to_s
      end
    end

    describe 'parent' do
      context 'with SOFTWARE granularity' do
        subject { FactoryGirl.build(:kalibro_module) }

        it 'should return nil' do
          expect(subject.parent).to be_nil
        end
      end

      context 'with CLASS granularity' do
        let(:granularity) { FactoryGirl.build(:granularity, type: KalibroClient::Entities::Miscellaneous::Granularity::CLASS) }
        let(:parent_granularity) { FactoryGirl.build(:granularity, type: KalibroClient::Entities::Miscellaneous::Granularity::PACKAGE) }
        let(:module_result) { FactoryGirl.build(:module_result) }
        let(:parent_module) { FactoryGirl.build(:kalibro_module, {granularity: parent_granularity, name: ['pre_name'], module_result: module_result}) }
        let!(:module_result_join) { mock('module_result_join') }

        context 'with a not persisted module with same name' do
          context 'and just one element on name' do
            subject { FactoryGirl.build(:kalibro_module, {granularity: granularity, name: ['name'], module_result: module_result}) }

            it 'should return a new Module with granularity SOFTWARE and name ROOT' do
              parent = subject.parent

              expect(parent.granularity.type).to eq(KalibroClient::Entities::Miscellaneous::Granularity::SOFTWARE)
              expect(parent.name).to eq(["ROOT"])
            end
          end

          context 'and more than one element on name' do

            before :each do
              KalibroClient::Entities::Miscellaneous::Granularity.any_instance.expects(:parent).returns(parent_granularity)

              module_result_join.expects(:where).with(long_name: parent_module.long_name, granularity: parent_module.granularity.to_s, 'module_results.processing_id' => parent_module.module_result.processing.id).returns([])
              KalibroModule.expects(:joins).with(:module_result).returns(module_result_join)
            end

            subject { FactoryGirl.build(:kalibro_module, {granularity: granularity, name: ['pre_name', 'name'], module_result: module_result}) }

            it 'should return a new Module with granularity PACKAGE and name pre_name' do
              parent = subject.parent

              expect(parent.granularity.type).to eq(KalibroClient::Entities::Miscellaneous::Granularity::PACKAGE)
              expect(parent.name).to eq(['pre_name'])
            end
          end
        end

        context 'with a already existing module with this name' do
          subject { FactoryGirl.build(:kalibro_module, {granularity: granularity, name: ['pre_name', 'name'], module_result: module_result}) }

          it 'is expected to find and return the existing module' do
            module_result_join.expects(:where).with(long_name: parent_module.long_name, granularity: parent_module.granularity.to_s, 'module_results.processing_id' => parent_module.module_result.processing.id).returns([parent_module])
            KalibroModule.expects(:joins).with(:module_result).returns(module_result_join)

            expect(subject.parent).to eq(parent_module)
          end
        end
      end
    end

    describe 'granularity=' do

      subject { FactoryGirl.build( :kalibro_module ) }

      it "is expected to convert the value to string" do
        granularity = mock("granularity")
        granularity.expects(:to_s).returns("CLASS")

        subject.granularity = granularity
      end
    end

    describe 'granularity' do

      subject { FactoryGirl.build( :kalibro_module ) }

      it 'is expected to return a KalibroClient::Entities::Miscellaneous::Granularity instance' do
        expect(subject.granularity).to be_a(KalibroClient::Entities::Miscellaneous::Granularity)
      end
    end

    # This tests covers a deprecated method and should be removed in the future
    describe 'module_results' do
      context 'when there is a module result associated' do
        let(:module_result) { FactoryGirl.build(:module_result) }

        before :each do
          subject.expects(:module_result).returns(module_result)
        end

        it 'is expected to return a list with the single module result associated with the kalibro module' do
          expect(subject.module_results).to eq([module_result])
        end
      end

      context 'when there is no module result associated' do
        before :each do
          subject.expects(:module_result).returns(nil)
        end

        it 'is expected to return an empty list' do
          expect(subject.module_results).to eq([])
        end
      end
    end
  end
end

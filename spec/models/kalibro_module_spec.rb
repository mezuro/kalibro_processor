require 'rails_helper'

describe KalibroModule, :type => :model do
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

        context 'with just one element on name' do
          subject { FactoryGirl.build(:kalibro_module, {granularity: granularity, name: ['name']}) }

          it 'should return a new Module with granularity SOFTWARE and name ROOT' do
            parent = subject.parent

            expect(parent.granularity.type).to eq(KalibroClient::Entities::Miscellaneous::Granularity::SOFTWARE)
            expect(parent.name).to eq(["ROOT"])
          end
        end

        context 'with just more than one element on name' do
          before :each do
            KalibroClient::Entities::Miscellaneous::Granularity.any_instance.expects(:parent).returns(FactoryGirl.build(:granularity, type: KalibroClient::Entities::Miscellaneous::Granularity::PACKAGE))
          end

          subject { FactoryGirl.build(:kalibro_module, {granularity: granularity, name: ['pre_name', 'name']}) }

          it 'should return a new Module with granularity PACKAGE and name pre_name' do
            parent = subject.parent

            expect(parent.granularity.type).to eq(KalibroClient::Entities::Miscellaneous::Granularity::PACKAGE)
            expect(parent.name).to eq(['pre_name'])
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
  end
end

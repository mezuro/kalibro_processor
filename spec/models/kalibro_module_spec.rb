require 'spec_helper'

describe Module do
  describe 'method' do
    describe 'short_name' do
      subject { FactoryGirl.build(:kalibro_module) }

      it 'should get the last element of the name' do
        subject.short_name.should eq(subject.name.last)
      end
    end

    describe 'long_name' do
      subject { FactoryGirl.build(:kalibro_module) }

      it 'should get the join the name' do
        subject.long_name.should eq(subject.name.join('.'))
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
          subject.parent.should be_nil
        end
      end

      context 'with CLASS granularity' do
        let(:granularity) { FactoryGirl.build(:granularity, type: Granularity::CLASS) }

        context 'with just one element on name' do
          subject { FactoryGirl.build(:kalibro_module, {granularity: granularity, name: ['name']}) }

          it 'should return a new Module with granularity SOFTWARE and name ROOT' do
            parent = subject.parent

            parent.granularity.type.should eq(Granularity::SOFTWARE)
            parent.name.should eq(["ROOT"])
          end
        end

        context 'with just more than one element on name' do
          before :each do
            Granularity.any_instance.expects(:parent).returns(FactoryGirl.build(:granularity, type: Granularity::PACKAGE))
          end

          subject { FactoryGirl.build(:kalibro_module, {granularity: granularity, name: ['pre_name', 'name']}) }

          it 'should return a new Module with granularity PACKAGE and name pre_name' do
            parent = subject.parent

            parent.granularity.type.should eq(Granularity::PACKAGE)
            parent.name.should eq(['pre_name'])
          end
        end
      end
    end
  end
end
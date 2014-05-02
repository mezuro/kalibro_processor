require 'spec_helper'

describe MetricResult do
  describe "method" do
    let!(:metric_configuration) { FactoryGirl.build(:metric_configuration) }
    before :each do
        KalibroGatekeeperClient::Entities::MetricConfiguration.expects(:find).
          at_least_once.returns(metric_configuration)
    end

    describe "initialize" do
      context "with valid attributes" do
        subject { FactoryGirl.build(:metric_result_with_value) }

        it 'should return an instance of MetricResult' do
          subject.should be_a(MetricResult)
        end

        it 'should have the right attributes' do
          subject.value.should eq(2.0)
        end

        it 'should have the average method' do
          subject.descendant_results = []
          subject.descendant_results.should respond_to :average
        end

        it { should belong_to(:module_result) }
      end
    end

    describe 'aggregated_value' do
      context 'when value is NaN and the descendant_results array is not empty' do
        subject { FactoryGirl.build(:metric_result) }

        it 'should calculate the average value of the descendant_results array' do
          subject.aggregated_value.should eq(2.0)
        end
      end

      context 'when the metric_results are not from a leaf module' do
        subject { FactoryGirl.build(:metric_result_with_value) }

        it 'should return the value' do
          subject.aggregated_value.should eq(subject.value)
        end
      end
    end

    describe 'range' do
      let!(:range) { FactoryGirl.build(:range) }
      let!(:yet_another_range) { FactoryGirl.build(:yet_another_range) }
      let!(:metric_result) { FactoryGirl.build(:metric_result_with_value) }

      before :each do
        KalibroGatekeeperClient::Entities::Range.expects(:ranges_of).
            with(metric_result.metric_configuration.id).returns([range, yet_another_range])
      end

      it 'should return the range that contains the aggregated value of the metric result' do
        metric_result.range.should eq(range)
      end
    end

    describe 'has_grade?' do
      subject { FactoryGirl.build(:metric_result) }

      context 'without a range' do
        before :each do
          subject.expects(:range).returns(nil)
        end

        it 'should return false' do
          subject.has_grade?.should be_false
        end
      end

      context 'with a range' do
        let!(:range) { FactoryGirl.build(:range) }

        before :each do
          subject.expects(:range).at_least_once.returns(range)
        end

        context 'without a reading' do
          before :each do
            range.expects(:reading).returns(nil)
          end

          it 'should return false' do
            subject.has_grade?.should be_false
          end
        end

        context 'with a reading' do
          before :each do
            range.expects(:reading).returns(FactoryGirl.build(:reading))
          end

          it 'should return true' do
            subject.has_grade?.should be_true
          end
        end
      end
    end

    describe 'grade' do
      subject { FactoryGirl.build(:metric_result) }

      it "should call range's grade" do
        range = FactoryGirl.build(:range)
        range.expects(:grade).returns(10.0)
        subject.expects(:range).returns(range)

        subject.grade
      end
    end
  end
end

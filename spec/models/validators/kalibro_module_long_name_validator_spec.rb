require 'rails_helper'
require 'validators/kalibro_module_long_name_validator'

RSpec.describe KalibroModuleLongNameValidator, :type => :model do
  describe 'methods' do
    describe 'validate' do
      subject { FactoryGirl.build(:kalibro_module) }
      let!(:module_result) { FactoryGirl.build(:module_result, kalibro_module: same_name) }
      let(:subject_module_result) { FactoryGirl.build(:module_result, processing: module_result.processing) }
      let(:same_name) { FactoryGirl.build(:kalibro_module) }
      let(:processing) { FactoryGirl.create(:processing) }

      context 'within the same processing' do
        context 'and with the same granularity' do
          context 'and the same long name' do
            before :each do
              subject.module_result = subject_module_result
              subject_module_result.kalibro_module = subject

              same_name.save
              module_result.save
            end

            it 'is expected to add an error to the record' do
              subject.save
              expect(subject.errors).not_to be_empty
            end
          end

          context 'and a different long name' do
            before :each do
              subject.module_result = subject_module_result
              subject_module_result.kalibro_module = subject
            end

            it 'is expected to NOT add any errors' do
              subject.save
              expect(subject.errors).to be_empty
            end
          end
        end

        context 'with a different granularity' do
          let(:granularity) { FactoryGirl.build(:class_granularity) }

          context 'and the same long name' do
            before :each do
              subject.module_result = subject_module_result
              subject_module_result.kalibro_module = subject
              subject.granularity = granularity

              same_name.save
              module_result.save
            end

            it 'is expected to NOT add any errors' do
              subject.save
              expect(subject.errors).to be_empty
            end
          end
        end
      end

      context 'within a different processing' do
        let(:different_processing) { FactoryGirl.create(:processing) }

        context 'and with the same granularity' do
          context 'and the same long name' do
            before :each do
              subject_module_result.processing = different_processing
              subject.module_result = subject_module_result
              subject_module_result.kalibro_module = subject

              same_name.save
              module_result.save
            end

            it 'is expected to NOT add any errors' do
              subject.save
              expect(subject.errors).to be_empty
            end
          end
        end
      end
    end
  end
end

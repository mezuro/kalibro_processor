require 'rails_helper'
require 'validators/kalibro_module_long_name_validator'

RSpec.describe KalibroModuleLongNameValidator, :type => :model do
  describe 'methods' do
    describe 'validate' do
      subject { FactoryGirl.build(:kalibro_module, module_result: module_result) }
      let!(:existing_processing)     { FactoryGirl.create(:processing) }
      let!(:existing_module_result)  { FactoryGirl.create(:module_result, kalibro_module: nil,
                                                          processing: existing_processing) }
      let!(:existing_kalibro_module) { FactoryGirl.create(:kalibro_module, module_result: existing_module_result) }

      context 'within the same processing' do
        let!(:module_result) { FactoryGirl.create(:module_result, kalibro_module: nil,
                                                  processing: existing_processing) }

        context 'and with the same granularity' do
          context 'and the same long name' do
            it 'is expected to add an error to the record' do
              subject.save
              expect(subject.errors).not_to be_empty
            end
          end

          context 'and a different long name' do
            it 'is expected to NOT add any errors' do
              subject.long_name.reverse!
              subject.save
              expect(subject.errors).to be_empty
            end
          end
        end

        context 'with a different granularity' do
          let(:granularity) { FactoryGirl.build(:class_granularity) }

          context 'and the same long name' do
            it 'is expected to NOT add any errors' do
              subject.granularity = granularity
              subject.save
              expect(subject.errors).to be_empty
            end
          end
        end
      end

      context 'within a different processing' do
        let!(:other_processing) { FactoryGirl.create(:processing) }
        let!(:module_result)    { FactoryGirl.create(:module_result, kalibro_module: nil,
                                                     processing: other_processing) }

        context 'and with the same granularity' do
          context 'and the same long name' do
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

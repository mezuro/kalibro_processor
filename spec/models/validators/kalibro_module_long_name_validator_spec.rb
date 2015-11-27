require 'rails_helper'
require 'validators/kalibro_module_long_name_validator'

RSpec.describe KalibroModuleLongNameValidator, :type => :model do
  describe 'methods' do
    describe 'validate' do
      subject { FactoryGirl.build(:kalibro_module) }
      let!(:module_result) { FactoryGirl.build(:module_result, kalibro_module: same_name) }
      let(:subject_module_result) { FactoryGirl.build(:module_result, processing: module_result.processing) }
      let(:same_name) { FactoryGirl.build(:kalibro_module) }

      context 'validating an unique long name within a processing' do
        before do
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
    end
  end
end

require 'rails_helper'

describe CompoundResultsCalculator::JavascriptEvaluator, :type => :model do
  describe 'method' do
    describe 'add_variable' do
      let(:value) { 2 }
      context 'with a valid identifier' do
        let(:identifier) { "code" }
        it 'is expected to add a variable to the context' do
          expect(subject.add_variable(identifier, value)).to eq(value)
        end
      end

      context 'with an invalid identifier' do
        let(:invalid_identifier) { "1code" }
        it 'is expected to raise a invalid identifier exception' do
          expect{ subject.add_variable(invalid_identifier, value) }.to raise_error(Errors::InvalidIdentifierError)
        end
      end
    end
  end
end
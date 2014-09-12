require 'rails_helper'
require 'compound_results'

describe CompoundResults::JavascriptEvaluator do
  describe 'method' do
    describe 'add_function' do
      let(:body) { "return 2;"}

      context 'with a valid identifier' do
        let(:identifier) { "code" }
        it 'is expected to add a function to the context' do
          expect(subject.add_function(identifier, body)).to be_a(V8::Function)
        end
      end

      context 'with an invalid identifier' do
        let(:invalid_identifier) { "1code" }
        it 'is expected to raise a invalid identifier exception' do
          expect{ subject.add_function(invalid_identifier, body) }.to raise_error(Errors::InvalidIdentifierError)
        end
      end
    end

    describe 'evaluate' do
      let(:identifier) { "code" }

      context 'before timeout' do
        it 'is expected to call V8 eval method' do
          V8::Context.any_instance.expects(:eval).with("#{identifier}()")
          subject.evaluate(identifier)
        end
      end

      context 'after timeout' do
        let(:infinite_loop) { "while (true) {;}"}
        it 'is expected to raise a V8 timeout exception' do
          subject = CompoundResults::JavascriptEvaluator.new(2000)
          subject.add_function(identifier, infinite_loop)
          expect{ subject.evaluate(identifier) }.to raise_error(V8::Error, 'Script Timed Out')
        end
      end
    end
  end
end

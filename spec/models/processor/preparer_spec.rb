require 'rails_helper'

describe Processor::Preparer, :type => :model do
  describe 'methods' do
    let(:processing) { FactoryGirl.build(:processing) }
    let(:runner) { Runner.new(processing.repository, processing) }
    describe 'prepare' do
      context 'when the base directory exists' do
      end

      context 'when the base directory does not exist' do
        let!(:dir) { YAML.load_file("#{Rails.root}/config/repositories.yml")["repositories"]["path"] }
        before :each do
          Dir.expects(:exists?).with(dir).returns(false)
        end

        it 'should raise a RunTimeError exception' do
          expect { Processor::Preparer.prepare(runner) }.to raise_error(RuntimeError)
        end
      end
    end
  end
end

=begin
def preparing_state_mocks
  ProcessTime.expects(:create).with(state: "PREPARING", processing: processing).returns(process_time)
  process_time.expects(:update)
  Dir.expects(:exists?).with("/tmp").at_least_once.returns(true)
  Digest::MD5.expects(:hexdigest).returns("test")
  Dir.expects(:exists?).with(code_dir).returns(false)
  KalibroGatekeeperClient::Entities::MetricConfiguration.expects(:metric_configurations_of).
  with(configuration.id).returns([metric_configuration, compound_metric_configuration])
end
=end
require 'rails_helper'
require 'processor'

describe Processor::Context do
  def metrics(*traits)
    traits.map { |trait| FactoryGirl.build(:metric_configuration, trait) }
  end

  let(:processing)          { FactoryGirl.build(:processing) }
  let(:repository)          { FactoryGirl.build(:repository) }
  let(:tree_native_metrics) { metrics(:flog, :cyclomatic, :maintainability) }
  let(:hotspot_metrics)     { metrics(:flay, :phpmd) }
  let(:compound_metrics)    { metrics(:flog_compound_metric_configuration, :saikuro_compound_metric_configuration) }
  let(:native_metrics)      { tree_native_metrics + hotspot_metrics }

  subject { described_class.new(processing: processing, repository: repository) }

  describe 'initialize' do
    it 'is expected to set the attributes' do
      expect(subject.repository).to eq(repository)
      expect(subject.processing).to eq(processing)
      expect(subject.native_metrics).to be_a(Hash).and(be_empty)
      expect(subject.compound_metrics).to be_empty
    end
  end

  describe 'metric selection methods' do
    before :each do
      native_metrics.each do |mc|
        subject.native_metrics[mc.metric.metric_collector_name] << mc
      end
      subject.compound_metrics = compound_metrics
    end

    describe 'tree_native_metrics' do
      it 'is expected to return only tree native metrics' do
        expect(subject.tree_native_metrics).to contain_exactly(*tree_native_metrics)
      end
    end

    describe 'tree_metrics' do
      it 'is expected to return only tree metrics' do
        expect(subject.tree_metrics).to contain_exactly(*tree_native_metrics, *compound_metrics)
      end
    end
  end
end

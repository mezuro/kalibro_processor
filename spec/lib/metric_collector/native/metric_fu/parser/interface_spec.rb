require 'rails_helper'
require 'metric_collector'

describe MetricCollector::Native::MetricFu::Parser::Interface do
  describe 'parse' do
    it 'is expected to raise a NotImplementedError' do
      expect { MetricCollector::Native::MetricFu::Parser::Interface.parse(nil) }.to raise_error(NotImplementedError)
    end
  end

  describe 'default_value' do
    it 'is expected to raise a NotImplementedError' do
      expect { MetricCollector::Native::MetricFu::Parser::Interface.default_value }.to raise_error(NotImplementedError)
    end
  end
end
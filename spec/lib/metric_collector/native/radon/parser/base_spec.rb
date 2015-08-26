require 'rails_helper'
require 'metric_collector'

describe MetricCollector::Native::Radon::Parser::Base do
  describe 'parse' do
    it 'is expected to raise a NotImplementedError' do
      expect { MetricCollector::Native::Radon::Parser::Base.parse(nil, nil, nil) }.to raise_error(NotImplementedError)
    end
  end

  describe 'default_value' do
    it 'is expected to raise a NotImplementedError' do
      expect { MetricCollector::Native::Radon::Parser::Base.default_value }.to raise_error(NotImplementedError)
    end
  end
end
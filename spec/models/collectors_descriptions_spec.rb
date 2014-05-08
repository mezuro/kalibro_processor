require 'spec_helper'

describe CollectorsDescriptions do
  describe 'methods' do
    describe 'analizo_description' do
      it 'should return a brief description of the Analizo metric collector' do
        CollectorsDescriptions.analizo_description.should be_a(String)
      end
    end
  end
end
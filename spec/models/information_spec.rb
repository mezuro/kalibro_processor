require 'rails_helper'

describe Information do
  describe 'data' do
    it 'is expected to return a hash with version, license and repository url' do
      expect(Information.data).to eq({version: Information::VERSION, license: Information::LICENSE, repository_url: Information::REPOSITORY_URL})
    end
  end
end

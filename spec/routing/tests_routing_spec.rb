require "rails_helper"

describe TestsController, :type => :routing do
  describe "routing" do
    context 'outside production environment' do
      it { is_expected.to route(:post, '/tests/clean_database').
                    to(controller: :tests, action: :clean_database) }
    end

    context 'under production environment' do
      before do
        @env = Rails.env
        Rails.env = 'production'
        Rails.application.reload_routes!
      end

      it { is_expected.to_not route(:post, '/tests/clean_database').
                    to(controller: :tests, action: :clean_database) }

      after do
        Rails.env = @env
        Rails.application.reload_routes!
      end
    end
  end
end
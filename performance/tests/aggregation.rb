require_relative '../performance'
require 'processor'

module Performance
  class Aggregation < Base
    def setup
      super

      @kalibro_configuration = FactoryGirl.create(:kalibro_configuration)
      @code_dir = "/tmp/test"
      @repository = FactoryGirl.create(:repository, scm_type: "GIT", kalibro_configuration: @kalibro_configuration, code_directory: @code_dir)
      @root_module_result = FactoryGirl.create(:module_result, id: nil, processing: nil)
      @processing = FactoryGirl.create(:processing, repository: @repository, root_module_result: @root_module_result, id: nil)
      @context = FactoryGirl.build(:context, repository: @repository, processing: @processing)
    end

    def subject
      Processor::Aggregator.task(context)
    end
  end
end

Performance::Aggregation.new.run

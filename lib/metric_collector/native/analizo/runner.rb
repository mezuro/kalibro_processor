module MetricCollector
  module Native
    module Analizo
      class Runner
        def initialize(attributes={repository_path: nil})
          @repository_path = attributes[:repository_path]
        end

        def run
          results = `analizo metrics #{@repository_path}`
          raise Errors::NotFoundError.new("BaseTool Analizo not found") if results.nil?
          raise Errors::NotReadableError.new("Directory not readable") if results.empty?
          results
        end
      end
    end
  end
end

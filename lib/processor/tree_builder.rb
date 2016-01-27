module Processor
  class TreeBuilder < ProcessingStep
    # Number not to small and not too large. If someday there is the need, this may be a configuration
    BATCH_SIZE = 100

    protected

    def self.task(runner)
      offset = 0
      module_results = module_result_batch(runner.processing, offset)
      while !module_results.empty?
        module_results.each do |module_result|
          set_parent(module_result, module_results, runner.processing)
        end
        offset += BATCH_SIZE
        module_results = module_result_batch(runner.processing, offset)
      end
    end

    def self.state
      "BUILDING"
    end

    private

    def self.module_result_batch(processing, offset)
      ModuleResult.where(processing: processing).limit(BATCH_SIZE).offset(offset)
    end

    def self.set_parent(module_result, module_results, processing)
      parent_module = module_result.kalibro_module.parent
      if parent_module.nil?
        processing.update(root_module_result: module_result)
      else
        module_result.update(parent: parent_result(parent_module, module_results, processing))
      end
    end

    def self.parent_result(parent_module, module_results, processing)
      parent_module_result = ModuleResult.find_by_module_and_processing(parent_module, processing)
      if parent_module_result.nil?
        parent_module_result = ModuleResult.create(kalibro_module: parent_module, processing: processing)
        parent_module.module_result = parent_module_result
        parent_module.save! unless parent_module.persisted?
        module_results << parent_module_result
      end

      return parent_module_result
    end
  end
end

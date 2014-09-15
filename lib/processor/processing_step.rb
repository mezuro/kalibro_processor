module Processor
  class ProcessingStep
    def self.perform(context)
      if context.processing.state == "CANCELED"
        raise Errors::ProcessingCanceledError
      else
        start = Time.now
        context.processing.update(state: self.state)
        self.task(context)
        ProcessTime.create(state: self.state, processing: context.processing, time: (Time.now - start))
      end
    end

    protected

    def self.state; raise NotImplementedError; end

    def self.task(context); raise NotImplementedError; end
  end
end
module Processor
  class ProcessingStep
    def self.perform(runner)
      if runner.processing.state == "CANCELED"
        raise Errors::ProcessingCanceledError
      else
        start = Time.now
        runner.processing.update(state: self.state)
        self.task(runner)
        ProcessTime.create(state: self.state, processing: runner.processing, time: (Time.now - start))
      end
    end

    protected

    def self.state; raise NotImplementedError; end

    def self.task(runner); raise NotImplementedError; end
  end
end
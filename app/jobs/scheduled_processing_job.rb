class ScheduledProcessingJob < ActiveJob::Base
  queue_as :default

  def perform(repository)
    new_processing = Processing.create(repository: repository, state: "PREPARING")
    ProcessingJob.perform_later(repository, new_processing)
  end
end
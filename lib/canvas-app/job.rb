module Canvas::App
  class Job
    def self.run_in_background(worker_class, params = {})
      Connection.create.qless.queues['jobs'].put(worker_class, params)
    end
  end
end

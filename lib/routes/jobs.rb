# frozen_string_literal: true

module Routes
  class Jobs
    def self.route(env)
      case env[:request_method]
      when :get
        handle_get_request(env)
      else
        raise NotFoundError, "Unsupported method for /jobs route: #{env[:request_method]}"
      end
    end

    def self.handle_get_request(env)
      job_id = env[:paths][1]

      case job_id
      when nil
        ResponseBuilder.build(400, body: { error: 'Job ID is required' })
      when 'all'
        ResponseBuilder.build(200, body: { jobs: ::Jobs::InsertProduct.statuses })
      else
        status = ::Jobs::InsertProduct.statuses[job_id]
        raise NotFoundError, "Job with ID #{job_id} not found" unless status

        ResponseBuilder.build(200, body: { job_id: job_id, status: status })
      end
    end
  end
end

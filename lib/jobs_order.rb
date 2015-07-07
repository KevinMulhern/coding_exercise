class JobsOrder

  attr_reader :sorted_jobs
  def initialize(jobs_string)
    @job_hash = parse(jobs_string)
    @sorted_jobs = []
  end

  def parse(jobs_string)
    job_hash = {}
    jobs_string.scan(/(\w) => ?(\w?)/).each do |job, dependency|
    job_hash[job] = dependency
    end
    return job_hash 
  end
end

p = JobsOrder.new("a =>")
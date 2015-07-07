class JobsOrder

  attr_reader :sorted_jobs
  def initialize(string)
    @job_hash = string_parse(string)
    @sorted_jobs = []
  end

end
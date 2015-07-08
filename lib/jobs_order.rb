class JobsOrder

  attr_reader :sorted_jobs
  def initialize(jobs_string)
    @jobs_hash = parse(jobs_string)
    @sorted_jobs = []
    @checked = check_jobs
  end

  def parse(jobs_string)
    jobs_hash = {}
    jobs_string.scan(/(\w) => ?(\w?)/).each do |job, dependency|
      raise ArgumentError, 'Job and dependencey cannot be the same' if job == dependency
      job_hash[job] = dependency
    jobs_hash[job] = dependency
    end
    return jobs_hash 
  end

  def check_jobs
    checked = {}
    @jobs_hash.each_key do |job|
      checked[job] = "unchecked"
    end
    return checked
  end

  def sort
    while @checked.values.include?("unchecked")
      @checked.each_pair do |job, status|
        visit(job) if status == "unchecked"
      end
    end
  end

  def visit(job)
    if @checked[job] == "temp_check"
      raise ArgumentError, "Jobs cannot have circular dependencies"
    elsif @checked[job] == "unchecked"
      @checked[job] = "temp_check"
      visit(@jobs_hash[job]) unless @jobs_hash[job].empty?
      @checked[job] = "checked"
      @sorted_jobs << job
    end   
  end

end

p = JobsOrder.new("a =>")
p.sort
p p.sorted_jobs
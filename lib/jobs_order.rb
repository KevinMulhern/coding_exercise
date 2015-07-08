class JobsOrder
  class CircularDependencyError < StandardError;end
  class SelfDependencyError < StandardError;end
  class InvalidDependencyError < StandardError;end

  attr_reader :sorted_jobs
  def initialize(jobs_string)
    @jobs_hash = parse(jobs_string)
    @sorted_jobs = []
    @checked = check_jobs
  end

  def parse(jobs_string)
    jobs_hash = {}
    jobs_string.scan(/(\w) => ?(\w?)/).each do |job, dependency|
      fail SelfDependencyError, 'job and dependency cannot be the same' if job == dependency
      jobs_hash[job] = dependency
    end
    invalid_dependency?(jobs_hash)
    return jobs_hash 
  end

  def sort
    while @checked.values.include?("unchecked")
      @checked.each_pair do |job, status|
        visit(job) if status == "unchecked"
      end
    end
  end


  private

    def visit(job)
      if @checked[job] == "temp_check"
        fail CircularDependencyError, "Jobs cannot have circular dependencies"
      elsif @checked[job] == "unchecked"
        @checked[job] = "temp_check"
        visit(@jobs_hash[job]) unless @jobs_hash[job].empty?
        @checked[job] = "checked"
        @sorted_jobs << job
      end   
    end

    def check_jobs
      checked = {}
      @jobs_hash.each_key do |job|
        checked[job] = "unchecked"
      end
      return checked
    end

    def invalid_dependency?(jobs_hash)
      jobs_hash.values.each do |dependency|
        if dependency != "" && !jobs_hash.has_key?(dependency)
          fail InvalidDependencyError,"Invalid dependency #{dependency}"
        end
      end
    end
end

require 'jobs_order'

describe JobsOrder do
  let(:jobs_order) { JobsOrder.new(jobs_string) } 

  describe "#parse" do
    let(:jobs_string) { "a =>" }

    it "convert the an inputted string into a hash" do
      jobs_order.parse(jobs_string).should be_eql({"a" => ""})
    end
  end

  describe "sorting jobs" do
    before(:each) do
      jobs_order.sort
    end
    context "given an empty string" do
      let(:jobs_string) { "" }

      it "should return []" do
        expect(jobs_order.sorted_jobs).to eql([])    
      end

      it "should equal zero elements" do 
        expect(jobs_order.sorted_jobs.size).to eql(0)
      end
    end

    context "given one job" do
      let(:jobs_string) { "a =>" }

      it "should return one one job" do
        expect(jobs_order.sorted_jobs).to eql(["a"])
      end

      it "should equal one elements" do 
        expect(jobs_order.sorted_jobs.size).to eql(1)
      end
    end

    context "given three jobs" do 
      let(:jobs_string) { "a =>\nb =>\nc =>" }

      it "should return abc job sequence" do
        expect(jobs_order.sorted_jobs).to eql(["a", "b", "c"])
      end

      it "should equal three elements" do 
        expect(jobs_order.sorted_jobs.size).to eql(3)
      end
    end

    context "given three jobs and one dependency" do 
      let(:jobs_string) { "a =>\nb => c\nc =>" }

      it "should return job sequence acb" do
        expect(jobs_order.sorted_jobs).to eql(["a", "c", "b"])
      end

      it "should be equal three elements" do 
        expect(jobs_order.sorted_jobs.size).to eql(3)
      end
    end

    context "given six jobs and four dependencies" do 
      let(:jobs_string) { "a =>\nb => c\nc => f\nd => a\n e => b\n f =>" }

      it "should return job sequence afcbde" do
        expect(jobs_order.sorted_jobs).to eql(["a", "f", "c", "b", "d", "e"])
      end

      it "should be equal to 6 elements" do
        expect(jobs_order.sorted_jobs.size).to eql(6)
      end
    end
  end

  describe "error scenarios" do

    context "given a job sequence with a self dependency" do
      let(:jobs_string) { "a =>\nb =>\nc => c" }

      it "should raise a self dependency error" do 
       expect{ jobs_order.sort }.to raise_error(JobsOrder::SelfDependencyError)
      end
    end


    context "given a job sequence with a circular dependency" do 
      let(:jobs_string) { "a =>\nb => c\nc => f\n d => a\ne =>\nf => b" }

      it "should raise a circular dependency error" do
        expect{ jobs_order.sort }.to raise_error(JobsOrder::CircularDependencyError)
      end
    end

    context "given a job sequence with a dependency that isnt a job" do
      let(:jobs_string) { "a => c\nb => d\nc => b\nd => e" }

      it "should raise a invalid dependency error" do 
        expect{ jobs_order.parse(jobs_string) }.to raise_error(JobsOrder::InvalidDependencyError)
      end       
    end
  end
end


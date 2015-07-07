require 'jobs_order'

describe JobsOrder do
      it "returns an empty sequence of jobs" do
        JobsOrder.parse_string("a =>").should be_eql(['a'])
      end
end

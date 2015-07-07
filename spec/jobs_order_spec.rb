require 'jobs_order'

describe JobsOrder do
  let(:jobs_order) { JobsOrder.new(jobs_string) } 

  describe "#parse" do
    let(:jobs_string) {"a =>"}

    it "convert the an inputted string into a hash" do
      jobs_order.parse(jobs_string).should be_eql({"a" => ""})
    end
  end
end

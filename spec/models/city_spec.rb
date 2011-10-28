require 'spec_helper'

describe City do
  it { should validate_presence_of :name }
  it { should validate_presence_of :code }

  describe "#to_s" do
    let(:city) { Fabricate.build :city, :name => "Nibelheim" }
    subject { city.to_s }
    it { should == "Nibelheim" }
  end
end

require 'spec_helper'
describe Alf do
  
  let(:lispy){ Alf.lispy(Alf::Environment.examples) } 
  
  let(:expected){[
    {:status => 20, :sid=>"S1", :name=>"Smith", :city=>"London"},
    {:status => 20, :sid=>"S4", :name=>"Clark", :city=>"London"}
  ]}
  
  it "should have a version number" do
    Alf.const_defined?(:VERSION).should be_true
  end
  
  it "should allow running a commandline like command" do
    op = lispy.run(['restrict', 'suppliers', '--', "city == 'London'"])
    op.to_a.should == expected
  end
  
  it "should allow compiling lispy expressions" do
    lispy.compile{
      (restrict :suppliers, lambda{ city == 'London'})
    }.to_a.should == expected
  end
  
end

require 'spec_helper'
module Alf
  module Operator::NonRelational
    describe Compact::BufferBased do
        
      let(:input) {[
        {:a => "via_method", :time => 1, :b => "b"},
        {:a => "via_method", :time => 1, :b => "b"},
        {:a => "via_method", :time => 2, :b => "b"},
        {:a => "via_reader", :time => 3, :b => "b"},
        {:a => "via_reader", :time => 3, :b => "b"},
      ]}
  
      let(:expected) {[
        {:a => "via_method", :time => 1, :b => "b"},
        {:a => "via_method", :time => 2, :b => "b"},
        {:a => "via_reader", :time => 3, :b => "b"},
      ]}
  
      subject{ operator.to_a }
  
      describe "when factored with commandline args" do
        let(:operator){ Compact::BufferBased.new }
        before{ operator.pipe(input) }
        it { should == expected }
      end
  
    end 
  end
end
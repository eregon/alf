require 'spec_helper'
module Alf
  describe Lispy, "Tuple(...)" do
    let(:lispy){ Alf.lispy }
    subject{ lispy.Tuple(h) }

    describe 'on an empty tuple' do
      let(:h){ {} }
      it{ should eq({}) }
    end

    describe 'on an valid tuple' do
      let(:h){ {:name => "Alf"} }
      it{ should eq({:name => "Alf"}) }
    end

    describe 'on an invalid tuple because of keys' do
      let(:h){ {12 => "Alf"} }
      specify{ lambda{subject}.should raise_error(ArgumentError) }
    end

    describe 'on an invalid tuple because of values' do
      let(:h){ {:name => nil} }
      specify{ lambda{subject}.should raise_error(ArgumentError) }
    end

    describe "on the documentation example" do
      specify{
        lispy.evaluate{
          Tuple(:pid => 'P1', :name => 'Nut', :color => 'red', :heavy => true)
        }.should eq(:pid => 'P1', :name => 'Nut', :color => 'red', :heavy => true)
      }
    end

  end
end

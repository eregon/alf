require File.expand_path('../spec_helper', __FILE__)
require 'stringio'
class Alf
  describe HashReader do

    let(:lines){ [{:id => 1},{:id => 2}]                 }
    let(:str)  { lines.collect{|s| s.inspect}.join("\n") }
    let(:io)   { StringIO.new(str) }

    let(:reader){ Alf::HashReader.new }

    before{ reader.input = io }

    it "should be enumerable" do
      reader.to_a.should == lines
    end

  end
end

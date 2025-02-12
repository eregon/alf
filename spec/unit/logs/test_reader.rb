require 'spec_helper'
module Alf
  shared_examples_for "A valid Logs::Reader instance" do

    specify{ reader.should be_a(::Alf::Logs::Reader) }
    
    it "should yield a pseudo-relation" do
      reader.all?{|tuple| tuple.is_a?(Hash)}.should be_true
    end
    
  end
  describe Logs::Reader do
    
    let(:input){ _("apache_combined.log", __FILE__) }
    
    describe "when called on a reader directly" do
      let(:reader){
        ::Alf::Logs::Reader.new(input)
      }
      it_should_behave_like "A valid Logs::Reader instance"
    end
    
    describe "when called through registered one" do
      let(:reader){
        ::Alf::Reader.reader(input)
      }
      it_should_behave_like "A valid Logs::Reader instance"
    end
    
    describe "when called through factory method" do
      let(:reader){
        ::Alf::Reader.logs(input)
      }
      it_should_behave_like "A valid Logs::Reader instance"
    end
    
    describe "the auto-detect feature" do
      let(:reader){ ::Alf::Logs::Reader.new(nil,nil,:file_format => nil) }
      let(:relation){ reader.to_rel }
      
      describe "on postgresql.log" do
        pending("postgresql log format seems broken") {
          before{ reader.pipe(_("postgresql.log", __FILE__)) }
          it_should_behave_like "A valid Logs::Reader instance"
          specify{ relation.should_not be_empty }
        }
      end
      
      describe "on apache_combined.log" do
        before{ reader.pipe(_("apache_combined.log", __FILE__)) }
        it_should_behave_like "A valid Logs::Reader instance"
        specify{ relation.should_not be_empty }
      end
        
    end

  end
end

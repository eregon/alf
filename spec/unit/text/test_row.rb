require 'spec_helper'
module Alf
  class Text::Renderer
    describe Row do
     
      let(:row){ Row.new(values) }

      describe "when single values are used only" do

        let(:values){ [ 10/3.0, true ] }
        specify "rendering_lines" do
          row.rendering_lines.should == ["| 3.333 | true |"]
          row.rendering_lines([10,5]).should == ["|      3.333 | true  |"]
        end

      end

      describe "when multiple-line values are used" do

        let(:values){ [ 10/3.0, [1, 2, 3] ] }

        specify "rendering_lines" do
          row.rendering_lines.should == ["| 3.333 | [1, 2, 3] |"]
        end

      end

    end
  end
end

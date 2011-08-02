module Alf
  module Operator::NonRelational
    # 
    # Clip input tuples to a subset of attributes
    #
    # SYNOPSIS
    #
    #   #{shell_signature}
    #
    # OPTIONS
    # #{summarized_options}
    #
    # DESCRIPTION
    #
    # This operator clips tuples on attributes whose names are specified in 
    # ATTR_LIST. This is similar to the relational PROJECT operator, expect
    # that CLIP does not remove duplicates afterwards.
    #
    # Clipping may therefore lead to bags of tuples instead of sets. The result
    # is **not** a valid relation unless a candidate key is preserved.
    #
    # With --allbut, the operator keeps attributes in ATTR_LIST, instead of 
    # projecting them away. 
    # 
    # EXAMPLE
    #
    #   alf clip suppliers -- name city
    #   alf clip suppliers --allbut -- name city
    #
    class Clip < Alf::Operator(__FILE__, __LINE__)
      include Operator::NonRelational, Operator::Transform
  
      signature do |s|
        s.argument :attr_list, AttrList, []
        s.option :allbut, Boolean, false, "Apply an allbut clipping?"
      end
      
      protected 
  
      # (see Operator::Transform#_tuple2tuple)
      def _tuple2tuple(tuple)
        @attr_list.project(tuple, @allbut)
      end
  
    end # class Clip
  end # module Operator::NonRelational
end # module Alf

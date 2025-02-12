module Alf
  module Operator::Relational
    class Summarize < Alf::Operator()
      include Operator::Relational, Operator::Shortcut, Operator::Unary
      
      signature do |s|
        s.argument :by,            AttrList, []
        s.argument :summarization, Summarization, {}
        s.option   :allbut,        Boolean, false, "Summarize on all but specified attributes?"
      end
      
      # Summarizes according to a complete order
      class SortBased
        include Operator, Operator::Cesure
  
        def initialize(by_key, allbut, summarization)
          @by_key, @allbut, @summarization = by_key, allbut, summarization
        end
  
        protected 
  
        # (see Operator::Cesure#project)
        def project(tuple)
          @by_key.project(tuple, @allbut)
        end
        
        # (see Operator::Cesure#start_cesure)
        def start_cesure(key, receiver)
          @aggs = @summarization.least
        end
  
        # (see Operator::Cesure#accumulate_cesure)
        def accumulate_cesure(tuple, receiver)
          @aggs = @summarization.happens(@aggs, tuple)
        end
  
        # (see Operator::Cesure#flush_cesure)
        def flush_cesure(key, receiver)
          @aggs = @summarization.finalize(@aggs)
          receiver.call key.merge(@aggs)
        end
  
      end # class SortBased

      # Summarizes in-memory with a hash
      class HashBased
        include Operator, Operator::Relational, Operator::Unary
  
        def initialize(by_key, allbut, summarization)
          @by_key, @allbut, @summarization = by_key, allbut, summarization
        end

        protected
        
        def _each
          index = Hash.new{|h,k| @summarization.least}
          each_input_tuple do |tuple|
            key, rest = @by_key.split(tuple, @allbut)
            index[key] = @summarization.happens(index[key], tuple)
          end
          index.each_pair do |key,aggs|
            yield key.merge(@summarization.finalize(aggs))
          end
        end
      
      end
        
      protected 
      
      def longexpr
        if @allbut
          chain HashBased.new(@by, @allbut, @summarization),
                datasets
        else
          chain SortBased.new(@by, @allbut, @summarization),
                Operator::NonRelational::Sort.new(@by.to_ordering),
                datasets
        end
      end
  
    end # class Summarize
  end # module Operator::Relational
end # module Alf

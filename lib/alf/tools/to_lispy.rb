module Alf
  module Tools

    # Myrrha rules for converting to ruby literals
    ToLispy = Myrrha::coercions do |r|
      
      # Delegate to #to_lispy if it exists
      lispy_able = lambda{|v,rd| v.respond_to?(:to_lispy)}
      r.upon(lispy_able) do |v,rd|
        v.to_lispy
      end

      # On AttrList
      r.upon(Types::AttrList) do |v, rd|
        Tools.to_ruby_literal(v.attributes)
      end

      # On Heading
      r.upon(Types::Heading) do |v, rd|
        Tools.to_ruby_literal(v.attributes)
      end

      # On Ordering
      r.upon(Types::Ordering) do |v, rd|
        Tools.to_ruby_literal(v.ordering)
      end

      # On Renaming
      r.upon(Types::Renaming) do |v, rd|
        Tools.to_ruby_literal(v.renaming)
      end

      # On Renaming
      r.upon(lambda{|v,rd| Iterator::Proxy === v}) do |v, rd|
        Tools.to_ruby_literal(v.dataset)
      end

      # On TupleExpression
      r.upon(Types::TupleExpression) do |v, rd|
        unless src = v.source
          raise NotImplementedError, "TupleExpression #{v} has no source"
        end
        "->(){ #{src} }"
      end

      # On TuplePredicate
      r.upon(Types::TuplePredicate) do |v, rd|
        unless src = v.source
          raise NotImplementedError, "TuplePredicate #{v} has no source"
        end
        "->(){ #{src} }"
      end

      # On TupleComputation
      r.upon(Types::TupleComputation) do |v, rd|
        "{" + v.computation.collect{|name,compu|
          [name.inspect, r.coerce(compu)].join(" => ")
        }.join(', ') + "}"
      end

      # On Aggregator
      r.upon(lambda{|v,_| Aggregator === v}) do |v, rd|
        unless src = v.source
          raise NotImplementedError, "Aggregator #{v} has no source"
        end
        src
      end

      # On Summarization
      r.upon(Types::Summarization) do |v, rd|
        "{" + v.aggregations.collect{|name,compu|
          [name.inspect, r.coerce(compu)].join(" => ")
        }.join(', ') + "}"
      end

      # On Command and Operator
      cmd = lambda{|v,_| (Command === v) || (Operator === v)}
      r.upon(cmd) do |v,rd|
        cmdname  = v.class.command_name.to_s.gsub('-', '_')
        oper, args, opts = v.class.signature.collect_on(v)
        args = opts.empty? ? (oper + args) : (oper + args + [ opts ])
        args = args.collect{|arg| r.coerce(arg)}
        "(#{cmdname} #{args.join(', ')})"
      end

      # Let's assume to to_ruby_literal will make the job
      r.fallback(Object) do |v, _|
        Tools.to_ruby_literal(v)
      end

    end
    
    # Delegated to ToLispy
    def to_lispy(value)
      ToLispy.apply(value)
    end
    
  end # module Tools
end # module Alf

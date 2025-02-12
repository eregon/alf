module Alf
  module Operator
    # 
    # Encapsulates method that allows making operator introspection, that is,
    # knowing operator cardinality and similar stuff.
    # 
    module ClassMethods

      #
      # Returns false
      #
      def command?
        false
      end
    
      #
      # Returns true
      #
      def operator?
        true
      end

      #
      # Returns true if this is a relational operator, false otherwise
      #
      def relational?
        ancestors.include?(Relational)
      end
    
      #
      # Returns true if this is a non relational operator, false otherwise
      #
      def non_relational?
        ancestors.include?(NonRelational)
      end
    
      #
      # Runs the command on commandline arguments
      #
      # @param [Array] argv an array of commandline arguments, typically ARGV
      # @param [Object] req an optional requester, typically a super command
      # @return [Iterator] an Iterator with query result
      #
      def run(argv, req = nil)
        inst, operands = from_argv(argv)

        # find standard input reader
        stdin_reader = if req && req.respond_to?(:stdin_reader)
          req.stdin_reader
        else 
          Reader.coerce($stdin)
        end

        # normalize operands
        operands = [ stdin_reader ] + Array(operands)
        operands = operands.collect{|op| 
          Iterator.coerce(op, req && req.environment)
        }
        operands = if nullary?
          []
        elsif unary?
          operands.last
        elsif binary?
          operands[-2..-1]
        end

        inst.pipe(operands, req && req.environment)
        inst
      end

      #
      # Returns true if this operator is a zero-ary operator, false otherwise
      #
      def nullary?
        ancestors.include?(Operator::Nullary)
      end

      #
      # Returns true if this operator is an unary operator, false otherwise
      #
      def unary?
        ancestors.include?(Operator::Unary)
      end

      #
      # Returns true if this operator is a binary operator, false otherwise
      #
      def binary?
        ancestors.include?(Operator::Binary)
      end

      #
      # Installs or set the operator signature
      #
      def signature
        if block_given?
          @signature = Signature.new(self, &Proc.new) 
          @signature.install
          options do |opt|
            signature.fill_option_parser(opt, self)
          end
        else
          @signature ||= Signature.new(self)
        end
      end
      
      private 

      # Factors an operator instance from commandline arguments
      def from_argv(argv)
        inst = new
        operands = inst.signature.parse_argv(argv, inst)
        [inst, operands]
      end

    end # module ClassMethods

    #
    # Yields non-relational then relational operators, in turn.
    #
    def self.each
      Operator::NonRelational.each{|x| yield(x)}
      Operator::Relational.each{|x| yield(x)}
    end
    
    # Ensures that the Introspection module is set on real operators
    def self.included(mod)
      mod.extend(ClassMethods) if mod.is_a?(Class)
    end
      
  end # module Operator
end # module Alf

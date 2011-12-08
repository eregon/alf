module Alf
  module Engine
    #
    # Provides in-memory materialization through a ruby Hash.
    #
    # This class acts as a Cog, that it, it is an enumerable of tuples. No 
    # particular ordering is guaranteed. In addition, the class provides 
    # indexed access through the `[]` method. 
    # 
    # Materialization occurs at prepare time, with auto-prepare on first 
    # access.
    #
    # Example:
    #
    #     rel = [
    #       {:name => "Jones", :city => "London"},
    #       {:name => "Smith", :city => "Paris"},
    #       {:name => "Blake", :city => "London"}
    #     ]
    #     op = Materialize::Hash.new(rel, AttrList[:city])
    #
    #     op.to_a 
    #     # => same as rel, no ordering guaranteed
    #
    #     op[:city => "London"].to_a
    #     # => [
    #            {:name => "Jones", :city => "London"},
    #            {:name => "Blake", :city => "London"}
    #          ]
    #
    #     op[:city => "London"].to_a
    #     # => [
    #            {:name => "Jones", :city => "London"},
    #            {:name => "Blake", :city => "London"}
    #          ]
    #
    #     op[:city => "Athens"].to_a
    #     # => []
    #
    class Materialize::Hash < Cog

      # @return [Enumerable] The operand
      attr_reader :operand

      # @return [AttrList] Attributes for the hash key
      attr_reader :key

      # @return [Boolean] Hash on all but specified attributes?
      attr_reader :allbut

      # Creates a Hash instance
      def initialize(operand, key, allbut = false)
        @operand = operand
        @key = key
        @allbut = allbut
        @materialized = nil
      end

      # (see Cog#each)
      def each(&block)
        materialized.each_value do |rel|
          rel.each(&block)
        end
      end

      # Returns tuples that match a given key.
      #
      # This method returns a Cog instance in all case. En empty Cog is 
      # returned if no tuples match the key.
      #
      # @param [Tuple] key a tuple key
      # @return [Cog] the tuples from operand that match `key`
      def [](key)
        m = materialized
        m.has_key?(key) ? m[key] : []
      end

      # (see Cog#prepare)
      #
      # Prepare through materialization of the operand as a hash
      def prepare
        @materialized ||= begin
          h = ::Hash.new{|h,k| h[k] = []}
          operand.each do |tuple|
            k = @key.project_tuple(tuple, @allbut)
            h[k] << tuple
          end
          h
        end
      end

      # (see Cog#free)
      #
      # Frees the materizalied hash
      def clean
        @materialized = nil
      end

      private 

      # @return [Hash] the materialized hash
      def materialized
        prepare
        @materialized
      end

    end # class Hash
  end # module Engine
end # module Alf

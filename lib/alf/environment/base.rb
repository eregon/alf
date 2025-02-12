module Alf
  class Environment
    module Base

      #
      # Returns a dataset whose name is provided.
      #
      # This method resolves named datasets to tuple enumerables. When the 
      # dataset exists, this method must return an Iterator, typically a 
      # Reader instance. Otherwise, it must throw a NoSuchDatasetError.
      #
      # @param [Symbol] name the name of a dataset
      # @return [Iterator] an iterator, typically a Reader instance
      # @raise [NoSuchDatasetError] when the dataset does not exists
      #
      def dataset(name)
      end
      undef :dataset
      
      #
      # Branches this environment and puts some additional explicit 
      # definitions.
      #
      # This method is provided for (with ...) expressions and should not
      # be overriden by subclasses.
      #
      # @param [Hash] a set of (name, Iterator) pairs.
      # @return [Environment] an environment instance with new definitions set
      #
      def branch(defs)
        Explicit.new(defs, self)
      end

    end # module Base
    include(Base)
  end # class Environment
end # module Alf

require 'rocket_pants/pagination/version'

module RocketPants
  #
  # Pagination support for RocketPants
  #
  # Include this module in your RocketPants controllers to add pagination
  # support.
  #
  # @author Alessandro Desantis <desa.alessandro@gmail.com>
  #
  module Pagination
    #
    # Reserved root keys
    #
    RESERVED_PAGINATION_KEYS = [:count, :pagination]

    #
    # Paginates the given relation.
    #
    # The page param is 'page' by default.
    #
    # @param [ActiveRecord::Relation] the relation to paginate
    # @param [Hash] an options hash for the #paginate method
    #
    # @return [ActiveRecord::Relation] a paginated relation
    #
    def paginate(relation, options = {})
      relation.paginate({ page: params[:page] }.merge(options))
    end

    #
    # Exposes the given collection with pagination metadata.
    #
    # @param [Hash{Symbol => ActiveRecord::Relation}] a hash with exactly one
    #   element, its key being the root key and its value a paginated relation
    #
    # @raise [ArgumentError] if the hash is malformed
    #
    def expose_with_pagination(hash)
      root_key, collection = extract_pagination_elements_from hash

      response = {
        "#{root_key}" => ActiveModel::ArraySerializer.new(collection),
        count: collection.count,
        pagination: {
          pages: collection.total_pages,
          current: collection.current_page,
          count: collection.count,
          per_page: collection.per_page,
          previous: collection.previous_page,
          next: collection.next_page
        }
      }

      expose response
    end

    #
    # Paginates and exposes the given collection with pagination metadata.
    #
    # Basically, just calls {#paginate}, then {#expose_with_pagination}.
    #
    # @param [Hash(Symbol => ActiveRecord::Relation)] a hash with exactly one
    #   element, its key being the root key and its value a paginated relation
    #
    # @raise [ArgumentError] if the hash is malformed
    #
    def paginate_and_expose(hash)
      root_key, collection = extract_pagination_elements_from hash
      expose_with_pagination "#{root_key}" => paginate(collection)
    end

    private

    #
    # Returns the first pair from the given hash.
    #
    # This is used to extract the root key and collection from a hash.
    #
    # @param [Hash(Symbol => ActiveRecord::Relation)] a hash with exactly one
    #   element, its key being the root key and its value a relation
    #
    # @return [Array(Symbol, ActiveRecord::Relation)] an array containing a root
    #   key and a relation
    #
    # @raise [ArgumentError] if the hash is malformed
    #
    def extract_pagination_elements_from(hash)
      validate_pagination_hash! hash
      hash.first
    end

    #
    # Validates the given hash.
    #
    # Ensures that the hash has exactly one element and that the first element's
    # key is not a reserved one.
    #
    # @param [Hash] a hash to validate
    #
    # @raise [ArgumentError] if the hash doesn't have exactly 1 element
    # @raise [ArgumentError] if the first element's key is a reserved one
    #
    def validate_pagination_hash!(hash)
      if hash.size != 1
        raise ArgumentError, "the given hash should contain exactly 1 element (#{hash.size} elements)"
      end

      if hash.keys.first.to_sym.in?(RESERVED_PAGINATION_KEYS)
        raise ArgumentError, "the given root key is reserved: #{hash.keys.first}"
      end
    end
  end
end

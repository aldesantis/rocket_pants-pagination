# frozen_string_literal: true
require 'rocket_pants'
require 'active_model_serializers'
require 'will_paginate'

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
    RESERVED_PAGINATION_KEYS = %i(count pagination).freeze
    private_constant :RESERVED_PAGINATION_KEYS

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
        root_key => ActiveModel::Serializer::ArraySerializer.new(collection),
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
      expose_with_pagination root_key => paginate(collection)
    end

    private

    def extract_pagination_elements_from(hash)
      validate_pagination_hash! hash
      hash.first
    end

    def validate_pagination_hash!(hash)
      fail(
        ArgumentError,
        "The hash should contain exactly 1 element (#{hash.size} given)"
      ) if hash.size != 1

      fail(
        ArgumentError,
        "#{hash.keys.first} is a reserved root key"
      ) if hash.keys.first.to_sym.in?(RESERVED_PAGINATION_KEYS)
    end
  end
end

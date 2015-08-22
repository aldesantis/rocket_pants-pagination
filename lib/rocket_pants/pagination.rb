require 'rocket_pants/pagination/version'

module RocketPants
  module Pagination
    DEFAULT_PAGINATION_OPTIONS = { per_page: 10 }
    RESERVED_PAGINATION_KEYS = [:count, :pagination]

    def paginate(relation, options = {})
      options = DEFAULT_PAGINATION_OPTIONS.merge(options)
      options = options.merge(page: params[:page])

      relation.paginate(options)
    end

    def expose_with_pagination(hash)
      root_key, collection = extract_pagination_elements_from hash

      response = {}
      response[root_key] = ActiveModel::ArraySerializer.new(collection)
      response[:count] = collection.count
      response[:pagination] = {
        pages: collection.total_pages,
        current: collection.current_page,
        count: collection.count,
        per_page: collection.per_page,
        previous: collection.previous_page,
        next: collection.next_page
      }

      expose response
    end

    def paginate_and_expose(hash)
      root_key, collection = extract_pagination_elements_from hash
      expose_with_pagination "#{root_key}" => paginate(collection)
    end

    private

    def extract_pagination_elements_from(hash)
      validate_pagination_hash! hash
      hash.first
    end

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

module RocketPants
  module Pagination
    module Swagger
      include ::Swagger::Blocks

      swagger_schema :RocketPants_Pagination do
        key :required, [:pages, :current, :count, :per_page]

        property :pages do
          key :type, :integer
          key :format, :int64
          key :description, 'the number of pages'
          key :default, 1
        end

        property :current do
          key :type, :integer
          key :format, :int64
          key :description, 'the number of the current page'
          key :default, 1
        end

        property :count do
          key :type, :integer
          key :format, :int64
          key :description, 'the number of total items'
          key :default, 1
        end

        property :per_page do
          key :type, :integer
          key :format, :int64
          key :description, 'the number of items per page'
          key :default, 1
        end

        property :previous do
          key :type, :integer
          key :format, :int64
          key :description, 'the number of the previous page (if available)'
          key :default, 1
        end

        property :next do
          key :type, :integer
          key :format, :int64
          key :description, 'the number of the next page (if available)'
          key :default, 1
        end
      end
    end
  end
end

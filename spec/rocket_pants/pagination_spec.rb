# frozen_string_literal: true
require 'spec_helper'

RSpec.describe 'RocketPants::Pagination' do
  subject do
    Class.new do
      include RocketPants::Pagination

      def params; { page: 1 }; end
      def expose(*); end
    end.new
  end

  describe '#paginate' do
    let(:relation) do
      Class.new do
      end.new
    end

    it 'paginates the provided relation' do
      expect(relation).to receive(:paginate)
        .with(page: 1, per_page: 10)
        .once

      subject.paginate(relation, per_page: 10)
    end
  end

  describe '#expose_with_pagination' do
    let(:paginated_collection) do
      Class.new do
        def count; 1; end
        def total_pages; 2; end
        def current_page; 3; end
        def per_page; 4; end
        def previous_page; 5; end
        def next_page; 6; end
      end.new
    end

    let(:serialized_collection) { instance_double('ActiveModel::Serializer::ArraySerializer') }

    before(:each) do
      allow(ActiveModel::Serializer::ArraySerializer).to receive(:new)
        .with(paginated_collection)
        .and_return(serialized_collection)
    end

    it 'exposes the collection with pagination metadata' do
      expect(subject).to receive(:expose)
        .with(a_hash_including(
          test_collection: serialized_collection,
          count: paginated_collection.count,
          pagination: {
            pages: paginated_collection.total_pages,
            current: paginated_collection.current_page,
            count: paginated_collection.count,
            per_page: paginated_collection.per_page,
            previous: paginated_collection.previous_page,
            next: paginated_collection.next_page
          }
        ))
        .once

      subject.expose_with_pagination(test_collection: paginated_collection)
    end
  end

  describe '#paginate_and_expose' do
    let(:collection) do
      Class.new do
      end.new
    end

    let(:paginated_collection) do
      Class.new do
        def count; 1; end
        def total_pages; 2; end
        def current_page; 3; end
        def per_page; 4; end
        def previous_page; 5; end
        def next_page; 6; end
      end.new
    end

    let(:serialized_collection) { instance_double('ActiveModel::Serializer::ArraySerializer') }

    before(:each) do
      allow(collection).to receive(:paginate)
        .and_return(paginated_collection)

      allow(ActiveModel::Serializer::ArraySerializer).to receive(:new)
        .with(paginated_collection)
        .and_return(serialized_collection)
    end

    it 'paginates and exposes the collection with pagination metadata' do
      expect(subject).to receive(:expose)
        .with(a_hash_including(
          test_collection: serialized_collection,
          count: paginated_collection.count,
          pagination: {
            pages: paginated_collection.total_pages,
            current: paginated_collection.current_page,
            count: paginated_collection.count,
            per_page: paginated_collection.per_page,
            previous: paginated_collection.previous_page,
            next: paginated_collection.next_page
          }
        ))
        .once

      subject.paginate_and_expose test_collection: collection
    end
  end
end

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
    let(:collection) do
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
        .with(collection)
        .and_return(serialized_collection)
    end

    it 'exposes the collection with pagination metadata' do
      expect(subject).to receive(:expose)
        .with(a_hash_including(
          test_collection: serialized_collection,
          count: collection.count,
          pagination: {
            pages: collection.total_pages,
            current: collection.current_page,
            count: collection.count,
            per_page: collection.per_page,
            previous: collection.previous_page,
            next: collection.next_page
          }
        ))
        .once

      subject.expose_with_pagination(test_collection: collection)
    end
  end
end

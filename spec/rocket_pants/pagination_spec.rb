# frozen_string_literal: true
require 'spec_helper'

RSpec.describe RocketPants::Pagination do
  subject do
    Class.new do
      # rubocop:disable RSpec/DescribedClass
      include RocketPants::Pagination
      # rubocop:enable RSpec/DescribedClass

      def params
        { page: 1 }
      end

      def expose(*); end
    end.new
  end

  let(:relation) do
    Class.new do
    end.new
  end

  let(:paginated_relation) do
    Class.new do
      def count
        1
      end

      def total_pages
        2
      end

      def current_page
        3
      end

      def per_page
        4
      end

      def previous_page
        5
      end

      def next_page
        6
      end
    end.new
  end

  let(:serialized_relation) { instance_double('ActiveModel::Serializer::CollectionSerializer') }

  let(:expected_hash) do
    {
      test_collection: serialized_relation,
      count: paginated_relation.count,
      pagination: {
        pages: paginated_relation.total_pages,
        current: paginated_relation.current_page,
        count: paginated_relation.count,
        per_page: paginated_relation.per_page,
        previous: paginated_relation.previous_page,
        next: paginated_relation.next_page
      }
    }
  end

  before(:each) do
    allow(relation).to receive(:paginate)
      .and_return(paginated_relation)

    allow(ActiveModel::Serializer::CollectionSerializer).to receive(:new)
      .with(paginated_relation)
      .and_return(serialized_relation)
  end

  describe '#paginate' do
    it 'paginates the provided relation' do
      expect(relation).to receive(:paginate)
        .with(page: 1, per_page: 10)
        .once

      subject.paginate(relation, per_page: 10)
    end
  end

  describe '#expose_with_pagination' do
    it 'exposes the collection with pagination metadata' do
      expect(subject).to receive(:expose)
        .with(a_hash_including(expected_hash))
        .once

      subject.expose_with_pagination(test_collection: paginated_relation)
    end
  end

  describe '#paginate_and_expose' do
    it 'paginates and exposes the collection with pagination metadata' do
      expect(subject).to receive(:expose)
        .with(expected_hash)
        .once

      subject.paginate_and_expose test_collection: relation
    end
  end
end

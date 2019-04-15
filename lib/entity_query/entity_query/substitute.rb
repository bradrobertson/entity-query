class EntityQuery
  module Substitute
    def self.build(category=nil, entity_class=nil, projection_class=nil, session: nil)
      category ||= :anything
      entity_class ||= Entity
      projection_class ||= Projection

      query = Substitute::EntityQuery.build(category, entity_class, projection_class, session: session)

      query
    end

    class Entity
      include Schema::DataStructure
    end

    class Projection
      include EntityProjection
    end

    class EntityQuery
      include Initializer
      initializer rw(:category), rw(:entity_class), rw(:projection_class)

      def self.build(category, entity_class, projection_class, session: nil)
        instance = new(category, entity_class, projection_class)

        instance
      end

      # Note this implementation is a copy of the operational query
      # object, so be aware if you're changing either of these
      def call(id, &condition)
        entity = entity_class.new
        projection = projection_class.new(entity)

        stream_data.each do |message_data|
          continue = condition.nil? || condition.call(message_data)
          break unless continue

          projection.(message_data)
        end

        entity
      end

      # Note this implementation is a copy of the operational query
      # object, so be aware if you're changing either of these
      def last(id, include: nil, &condition)
        entity = entity_class.new
        projection = projection_class.new(entity)

        latest_version = -1
        stream_data.each do |message_data|
          latest_version += 1
          project = condition.nil? || condition.call(message_data)

          projection.(message_data) if project
        end

        return entity, latest_version if include == :latest_version

        entity
      end

      def stream_data
        @stream_data ||= []
      end

      def stream_data=(data)
        @stream_data = Array(data)
      end
    end
  end
end

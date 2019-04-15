class EntityQuery
  module Controls
    module EntityQuery
      def self.example(session: nil)
        entity_query = ::EntityQuery.build(category, entity_class, projection_class, session: session)

        entity_query
      end

      def self.id
        ID.example
      end

      def self.category
        :holding
      end

      def self.entity_class
        Controls::Holding
      end

      def self.projection_class
        Controls::Projection
      end

      class Configured
        include Dependency

        dependency :entity_query, ::EntityQuery

        def configure(session: nil)
          ::EntityQuery.configure(self, EntityQuery.category, EntityQuery.entity_class, EntityQuery.projection_class, session: session)
        end

        def self.build(session: nil)
          instance = new
          instance.configure(session: session)

          instance
        end

        def self.example
          build
        end

        def call(id, &condition)
          entity_query.(id, &condition)
        end
      end
    end
  end
end

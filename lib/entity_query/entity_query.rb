class EntityQuery
  include Initializer
  include Dependency
  include Configure

  initializer :category, :entity_class, :projection_class
  attr_accessor :session

  configure :entity_query

  dependency :read, MessageStore::Postgres::Read

  def self.build(category, entity_class, projection_class, session: nil)
    instance = new(category, entity_class, projection_class)

    instance.session = session

    instance
  end

  def call(entity_id, &condition)
    stream_name = MessageStore::StreamName.stream_name(category, entity_id)

    entity = entity_class.new
    projection = projection_class.new(entity)

    MessageStore::Postgres::Read.configure(self, stream_name, session: session)

    read.() do |message_data|
      continue = condition.nil? || condition.call(message_data)
      break unless continue

      projection.(message_data)
    end

    entity
  end

  def last(entity_id, include: nil, &condition)
    stream_name = MessageStore::StreamName.stream_name(category, entity_id)

    entity = entity_class.new
    projection = projection_class.new(entity)

    MessageStore::Postgres::Read.configure(self, stream_name, session: session)

    latest_version = -1
    read.() do |message_data|
      latest_version = message_data.position
      project = condition.nil? || condition.call(message_data)

      projection.(message_data) if project
    end

    return entity, latest_version if include == :latest_version

    entity
  end
end

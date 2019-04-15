# Entity Query Component

This component provides a basic interface for querying entities from a stream.

The purpose is to provide a facility for querying an entity up to a specific
version as specified by a block condition.

Concrete components should be able to configure this general component to their needs.

This object has 2 invocation points: `call` and `last`. See below for the 'last' explanation.

The intended usage is something like this. Obviously it doesn't *need* to be in a handler.
This is just for illustrative purposes.

```
class SomeHandler
  include Messaging::Handle
  include Messaging::StreamName

  dependency :entity_query, EntityQuery

  category :some_category

  def configure(session)
    EntityQuery.configure(self, category, SomeEntity, SomeProjection, session: session)
  end

  handle SomeEvent do |evt|
    entity = entity_query.(evt.some_id) do |message|
      message.some.condition == true
    end
  end

  handle SomeOtherEvent do |evt|
    # I've imagined some other implementations that might be useful like:

    entity = entity_query.project_while(evt.some_id) do |message|
      message.some.condition == true
    end

    entity = entity_query.project_until(evt.some_id) do |message|
      message.some.condition == true
    end

    entity = entity_query.project_if(evt.some_id) do |message|
      message.some.condition == true
    end
    ... etc
  end
end
```

Some things to note that may need clarification/justification:

1. The `last` message is perhaps an odd name. At the time, in my head, it was really to represent
projecting a stream up until the "last" matching event. In reality it's kind of just a
"project if" (condition block matches)

2. The `latest_version` is purposefully named differently than `current_version`.
This is to reflect that the stream itself may have a different "version" than the returned entity
after you've conditionally projected some events. You still, however need to know the expected
"next" version to write. This was the best name I could come up with

3. I couldn't figure out how to configure Read appropriately, so it happens during
actuation of the actual query object, which makes substitution rather difficult

4. The tests use an entity called a "holding". It could probably be changed to something
less domain specific

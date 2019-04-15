require_relative '../../automated_init'

context "Substitute" do
  context "Last" do
    query = EntityQuery::Substitute.build('someCategory', EntityQuery::Controls::Holding, EntityQuery::Controls::Projection)

    stream_data = [
      EntityQuery::Controls::MessageData.example(type: 'Changed', data: {value: 111.0}),
      EntityQuery::Controls::MessageData.example(type: 'Changed', data: {value: 222.0}),
      EntityQuery::Controls::MessageData.example(type: 'Changed', data: {value: 333.0})
    ]

    query.stream_data = stream_data

    test "it iterates the whole stream but only projects blocks that return true" do
      entity = query.last(123) do |message_data|
        message_data.data[:value] == 111 || message_data.data[:value] == 333
      end

      assert entity.value == 333
    end
  end
end

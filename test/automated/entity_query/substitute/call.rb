require_relative '../../automated_init'

context "Substitute" do
  context "Call" do
    query = EntityQuery::Substitute.build('someCategory', EntityQuery::Controls::Holding, EntityQuery::Controls::Projection)

    stream_data = [
      EntityQuery::Controls::MessageData.example(type: 'Changed', data: {value: 111.0}),
      EntityQuery::Controls::MessageData.example(type: 'Changed', data: {value: 222.0}),
      EntityQuery::Controls::MessageData.example(type: 'Changed', data: {value: 333.0})
    ]

    query.stream_data = stream_data

    test "the entity is projected until the block fails" do
      entity = query.(123) do |message_data|
        message_data.data[:value] == 111
      end

      assert entity.value == 111
    end
  end
end

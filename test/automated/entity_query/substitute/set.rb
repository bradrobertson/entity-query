require_relative '../../automated_init'

context "Substitute" do
  context "Set" do
    query = EntityQuery::Substitute.build
    stream_data = [
      EntityQuery::Controls::MessageData.example(type: 'Abc'),
      EntityQuery::Controls::MessageData.example(type: 'Def'),
    ]

    query.stream_data = stream_data

    test "stream_data is iterated" do
      messages = []
      query.(123) do |message_data|
        messages << message_data
      end

      assert messages == stream_data
    end
  end
end

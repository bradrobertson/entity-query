require_relative '../../../automated_init'

context "Substitute" do
  context "Last" do
    context "Include Version" do
      query = EntityQuery::Substitute.build('someCategory', EntityQuery::Controls::Holding, EntityQuery::Controls::Projection)

      context "no_stream has been created" do
        test "it returns -1 for the version" do
          entity, version = query.last(123, include: :latest_version)

          assert version == -1
        end
      end

      context "stream has been created" do
        stream_data = [
          EntityQuery::Controls::MessageData.example(type: 'Changed', data: {value: 111.0})
        ]

        query.stream_data = stream_data

        test "it returns the current version of the stream" do
          entity, version = query.last(123, include: :latest_version)

          assert version == 0
        end
      end
    end
  end
end

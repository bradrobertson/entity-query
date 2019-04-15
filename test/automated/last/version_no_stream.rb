require_relative './../automated_init'

context "EntityQuery" do
  context "Last matching block" do
    context "No Stream" do
      query = EntityQuery::Controls::EntityQuery.example
      holding_id = EntityQuery::Controls::EntityQuery.id

      test "no_stream yields correct version" do
        holding, version = query.last(holding_id, include: :latest_version)

        assert version == -1
      end
    end
  end
end

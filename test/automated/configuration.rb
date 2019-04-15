require_relative './automated_init'

context "Configuration" do
  query = EntityQuery::Controls::EntityQuery::Configured.example

  test "category configuration" do
    assert EntityQuery::Controls::EntityQuery.category == query.entity_query.category
  end

  test "querying" do
    holding_id = EntityQuery::Controls::EntityQuery.id

    write = Messaging::Postgres::Write.build

    stream_name = Messaging::StreamName.stream_name(holding_id, EntityQuery::Controls::EntityQuery.category)

    first = EntityQuery::Controls::Changes.first(holding_id)
    write.(first, stream_name)

    holding = query.(holding_id)

    assert holding.id == first.holding_id
    assert holding.report_date == Date.parse(first.report_date)
    assert holding.value == first.value
  end
end

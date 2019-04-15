require_relative './automated_init'

context "Query" do
  query = EntityQuery::Controls::EntityQuery.example

  holding_id = EntityQuery::Controls::EntityQuery.id

  write = Messaging::Postgres::Write.build

  stream_name = Messaging::StreamName.stream_name(holding_id, EntityQuery::Controls::EntityQuery.category)

  first = EntityQuery::Controls::Changes.first(holding_id)
  second = EntityQuery::Controls::Changes.second(holding_id)
  third = EntityQuery::Controls::Changes.third(holding_id)

  write.(first, stream_name)
  write.(second, stream_name)
  write.(third, stream_name)

  test "no conditions" do
    holding = query.(holding_id)

    assert holding.id == third.holding_id
    assert holding.report_date == Date.parse(third.report_date)
    assert holding.value == third.value
  end

  test "no met conditions" do
    holding = query.(holding_id) do |message_data|
      Date.parse(message_data.data[:report_date]) < Date.parse(first.report_date)
    end

    assert holding.id.nil?
    assert holding.report_date.nil?
    assert holding.value.nil?
  end

  test "met conditions" do
    holding = query.(holding_id) do |message_data|
      Date.parse(message_data.data[:report_date]) <= Date.parse(first.report_date)
    end

    assert holding.id == first.holding_id
    assert holding.report_date == Date.parse(first.report_date)
    assert holding.value == first.value
  end
end

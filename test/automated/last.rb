require_relative './automated_init'

# I'm not sure if "last" is the best naming, but it's to convey that we project
# up until the last event that returns true.
context "Last matching block" do
  query = EntityQuery::Controls::EntityQuery.example

  holding_id = EntityQuery::Controls::EntityQuery.id

  write = Messaging::Postgres::Write.build

  stream_name = Messaging::StreamName.stream_name(holding_id, EntityQuery::Controls::EntityQuery.category)

  first = EntityQuery::Controls::Changes.first(holding_id)
  second = EntityQuery::Controls::Changes.second(holding_id)
  third = EntityQuery::Controls::Changes.third(holding_id)
  # This one has an earlier date than third
  fourth = EntityQuery::Controls::Changes.second(holding_id)
  fifth = EntityQuery::Controls::Changes.third(holding_id)

  write.(first, stream_name)
  write.(second, stream_name)
  write.(third, stream_name)
  write.(fourth, stream_name)
  write.(fifth, stream_name)

  test "no conditions" do
    holding = query.last(holding_id)

    assert holding.id == fifth.holding_id
    assert holding.report_date == Date.parse(fifth.report_date)
    assert holding.value == fifth.value
  end

  test "no met conditions" do
    holding = query.last(holding_id) do |message_data|
      Date.parse(message_data.data[:report_date]) < Date.parse(first.report_date)
    end

    assert holding.id.nil?
    assert holding.report_date.nil?
    assert holding.value.nil?
  end

  test "met conditions" do
    holding = query.last(holding_id) do |message_data|
      Date.parse(message_data.data[:report_date]) <= Date.parse(fourth.report_date)
    end

    assert holding.id == fourth.holding_id
    assert holding.report_date == Date.parse(fourth.report_date)
    assert holding.value == fourth.value
  end

  # This feels a *bit* odd, but I need to deal with concurrency protection
  # so I need to know the last_written message version. This can only work
  # on this 'last' method (not call) since it forces the reader to iterate over
  # all messages in the stream anyway.
  # Alternatively we could fetch the current version from the stream if requested
  context ":latest_version" do
    test "met condition" do
      holding, version = query.last(holding_id, include: :latest_version) do |message_data|
        Date.parse(message_data.data[:report_date]) <= Date.parse(fourth.report_date)
      end

      assert 4 == version
    end

    test "no met condition" do
      holding, version = query.last(holding_id, include: :latest_version) do |message_data|
        Date.parse(message_data.data[:report_date]) < Date.parse(first.report_date)
      end

      assert 4 == version
    end
  end
end

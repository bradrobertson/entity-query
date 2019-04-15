require_relative './automated_init'

context "Build" do
  session = MessageStore::Postgres::Session.build
  example = EntityQuery::Controls::EntityQuery.example(session: session)

  test "category required" do
    assert example.category == EntityQuery::Controls::EntityQuery.category
  end

  test "entity_class required" do
    assert example.entity_class == EntityQuery::Controls::EntityQuery.entity_class
  end

  test "projection_class required" do
    assert example.projection_class == EntityQuery::Controls::EntityQuery.projection_class
  end

  test "reader initialized" do
    assert example.read
  end

  # TODO this isn't currently possible simply through `build` since
  # we'd need the full stream name to configure the Read dependency
  # Instead, we're just configuring it on each actuation of the instance

  # test "session shared" do
  #   assert example.read.session.object_id == session.object_id
  # end
end

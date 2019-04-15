require_relative '../../automated_init'

context "Substitute" do
  context "Build" do
    substitute = EntityQuery::Substitute.build(:anything)

    test "call returns an entity" do
      entity = substitute.(123)

      assert EntityQuery::Substitute::Entity == entity.class
    end

    test "last returns an entity" do
      entity = substitute.last(123)

      assert EntityQuery::Substitute::Entity == entity.class
    end
  end
end

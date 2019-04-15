class EntityQuery
  module Controls
    class Changed
      include Messaging::Message

      attribute :holding_id, String
      attribute :report_date, String
      attribute :value, Float
    end
  end
end

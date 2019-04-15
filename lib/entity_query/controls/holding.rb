class EntityQuery
  module Controls
    class Holding
      include Schema::DataStructure

      attribute :id, String
      attribute :report_date, Date
      attribute :value, Float
    end
  end
end

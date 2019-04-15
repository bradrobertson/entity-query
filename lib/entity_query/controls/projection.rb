class EntityQuery
  module Controls
    class Projection
      include EntityProjection

      entity_name :holding

      apply Changed do |changed|
        holding.id = changed.holding_id
        holding.report_date = changed.report_date && Date.parse(changed.report_date)
        holding.value = Float(changed.value)
      end
    end
  end
end

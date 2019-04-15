class EntityQuery
  module Controls
    module Changes
      def self.first(id)
        Changed.build(
          holding_id: id,
          report_date: '2018-01-01',
          value: 11.1
        )
      end

      def self.second(id)
        Changed.build(
          holding_id: id,
          report_date: '2018-02-01',
          value: 22.2
        )
      end

      def self.third(id)
        Changed.build(
          holding_id: id,
          report_date: '2018-03-01',
          value: 33.3
        )
      end
    end
  end
end

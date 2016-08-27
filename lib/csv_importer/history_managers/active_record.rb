require_relative "../history_manager/base.rb"

module CSVImporter
  module HistoryManager
    class ActiveRecord < Base
      def filter_data_with_history(row)
        reference = row.columns.delete("reference")
        select_column = row.columns.keys.join(", ")

        query = <<-SQL.gsub(/[\n\t\s]+/, ' ')
          SELECT *
          FROM csv_importer_histories AS cih
          WHERE
            cih.`reference`=#{connection.quote(reference)}
            AND cih.`table`=#{connection.quote(row.table)};
        SQL

        records = connection.execute(query, { as: :array, cast: true }).to_a
        return row if records.empty?

        history = Hash.new { |h, k| h[k] = [] }
        records.map { |k, v| history[k] << v }

        row.columns.each do |column_name, column_value|
          row.columns.delete(column_name) if history[column_name].include?(column_value)
        end
        row.columns.merge(reference: reference)
        row
      end

      def update_history(row)
        reference = row.columns.delete("reference")
        return if row.columns.empty?

        columns_name = row.columns.keys.sort
        records = []

        query = "INSERT INTO csv_importer_histories (#{connection.quote(columns.map(&:to_s).join(", "))}) VALUES"

        puts query

        # row.columns

        # records =
        # connection.execute()
      end

      private
      def connection
        @ar_connection ||= ::ActiveRecord::Base.connection
      end
    end
  end
end
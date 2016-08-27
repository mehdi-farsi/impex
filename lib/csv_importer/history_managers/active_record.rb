require_relative "../history_manager/base.rb"

module CSVImporter
  module HistoryManager
    class ActiveRecord < Base
      def filter_data_with_history(row)
        reference = row.columns["reference"]
        select_column = row.columns.keys.join(", ")

        query = <<-SQL.gsub(/[\n\t\s]+/, ' ')
          SELECT *
          FROM csv_importer_histories AS cih
          WHERE
            cih.`reference`=#{connection.quote(reference)}
            AND cih.`table`=#{connection.quote(row.table)};
        SQL

        records = connection.execute(query, { as: :array, cast: false }).to_a
        return row if records.empty?

        history = Hash.new { |h, k| h[k] = [] }

        records.each { |record| history[record["key"]] << record["value"] }

        row.columns.each do |column_name, column_value|
          row.columns.delete(column_name) if history[column_name].include?(column_value)
        end
        row
      end

      def update_history(row)
        reference = row.columns.delete("reference")
        return if row.columns.empty?

        records = []
        fields = row.columns.keys.join(", ")

        query = <<-SQL.gsub(/[\n\t\s]+/, ' ')
          INSERT INTO
          csv_importer_histories
          (`reference`, `table`, `key`, `value`)
          VALUES
        SQL

        row.columns.each do |column_name, column_value|
          values = [
            reference,
            row.table,
            column_name, column_value].map do |value|
              connection.quote(value)
            end.join(',')
          records << "(#{values})"
        end

        query << "#{records.join(',')};"
        connection.execute(query)
      end

      private
      def connection
        @ar_connection ||= ::ActiveRecord::Base.connection
      end
    end
  end
end
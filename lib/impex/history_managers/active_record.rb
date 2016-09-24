require_relative "../history_manager/base.rb"

module Impex
  module HistoryManager
    class ActiveRecord < Base
      def filter_data_with_history(row)
        reference = row.columns[@options[:history_references][row.table.to_sym].to_s || "reference"]
        select_column = row.columns.keys.join(", ")
        whitelist = @whitelist[row.table]

        query = <<-SQL.gsub(/[\n\t\s]+/, ' ')
          SELECT *
          FROM #{history_table} AS cih
          WHERE
            cih.`reference`=#{quote(reference)}
            AND cih.`table`=#{quote(row.table)}
        SQL

        query << "AND cih.`key` IN (#{quote(whitelist).join(',')})" unless whitelist.nil? || whitelist.empty?

        records = connection.exec_query(query).to_hash
        return row if records.empty?

        history = Hash.new { |h, k| h[k] = [] }

        records.each { |record| history[record["key"]] << record["value"] }

        row.columns.each do |column_name, column_value|
          row.columns.delete(column_name) if history[column_name].include?(column_value)
        end
        row
      end

      def update_history(row)
        reference = row.columns.delete(@options[:history_references][row.table.to_sym].to_s || "reference")
        return if row.columns.empty?

        query = <<-SQL.gsub(/[\n\t\s]+/, ' ')
          INSERT INTO
          #{history_table}
          (`reference`, `table`, `key`, `value`)
          VALUES
        SQL

        records = []
        row.columns.each do |column_name, column_value|
          next unless whitelist_include?(row.table, column_name)
          values = [
            reference,
            row.table,
            column_name, column_value
          ].map { |value| quote(value) }.join(',')

          records << "(#{values})"
        end

        query << "#{records.join(',')};"
        connection.execute(query) unless records.empty?
      end

      private
      def whitelist_include?(table, key)
        # if list not provided then accept any fields
        return true if @whitelist[table].nil? || @whitelist[table].empty?
        return true if @whitelist[table].map(&:to_s).include?(key.to_s)
        false
      end

      def history_table
        @history_table ||= @options[:history_manager][:table] || "impex_histories"
      end

      def connection
        @ar_connection ||= ::ActiveRecord::Base.connection
      end

      def quote(value)
        if value.is_a? Array
          value.map { |v| connection.quote(v) }
        else
          connection.quote(value)
        end
      end
    end
  end
end
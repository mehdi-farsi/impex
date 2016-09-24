$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'minitest/autorun'

require "active_record"
require 'active_support'

require "minitest/reporters"
require 'mocha/setup'

require 'impex'


Minitest::Reporters.use!

ActiveRecord::Base.establish_connection adapter: "sqlite3", database: ":memory:"

ActiveRecord::Migration.new.create_table :buildings do |t|
  t.string :reference
  t.string :address
  t.string :zip_code
  t.string :city
  t.string :country
  t.string :manager_name

  t.timestamps null: false
end

class Building < ActiveRecord::Base
end


def config_test
  @config ||= {
    file_loader: { loader: :file_system, path: "data/" },
    history_manager: { manager: :active_record, table: "impex_histories" },
    history_whitelisting: {}
  }
end
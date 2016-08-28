class CreateCsvImporterHistory < ActiveRecord::Migration
  def change
    create_table :csv_importer_histories do |t|
      t.column :reference, :string
      t.column :table, :string

      t.column :key, :string
      t.column :value, :string
    end

    add_index(:csv_importer_histories, [:reference, :table], order: {reference: :desc, table: :desc})
  end
end
class CreateImpexHistories < ActiveRecord::Migration
  def change
    create_table :impex_histories do |t|
      t.column :reference, :string
      t.column :table, :string

      t.column :key, :string
      t.column :value, :string
    end

    add_index(:impex_histories, [:reference, :table], order: {reference: :desc, table: :desc})
  end
end
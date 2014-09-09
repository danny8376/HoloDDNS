class CreateRecords < ActiveRecord::Migration
  def change
    create_table :records do |t|
      t.string :domain, limit: 253, null: false
      t.integer :rtype, null: false
      t.binary :value, null: false
    end

    add_index :records, :domain
    add_index :records, :value, unique: true
  end
end

class CreateRecords < ActiveRecord::Migration
  def change
    create_table :records do |t|
      t.integer :user_id, null: false
      t.string :domain,   null: false

      t.timestamps
    end
  end
end

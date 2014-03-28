class AddRecordsIndex < ActiveRecord::Migration
  def change
    add_index :records, :user_id
  end
end

class CreateUnapprovedRecords < ActiveRecord::Migration[5.1]
  def change
    create_table :unapproved_records, {:sequence_start_value => '1 cache 20 order increment by 1'} do |t|
      t.integer :approvable_id
      t.string :approvable_type
      t.timestamps null: false      

      t.index([:approvable_id, :approvable_type], unique: true, name: :uk_unapproved_records)
    end
  end
end
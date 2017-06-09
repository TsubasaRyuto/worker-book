class CreateWorkerAddresses < ActiveRecord::Migration[5.0]
  def change
    create_table :worker_addresses, id: false do |t|
      t.integer :id, null: false
      t.string :postcode, limit: 7, null: false
      t.string :prefecture, limit: 2
      t.string :city, limit: 200
      t.string :house_number, limit: 200
      t.string :phone_number, limit: 13

      t.timestamps
    end
    add_index :worker_addresses, :id, unique: true
  end
end

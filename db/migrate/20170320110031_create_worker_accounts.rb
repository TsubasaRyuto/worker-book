class CreateWorkerAccounts < ActiveRecord::Migration[5.0]
  def change
    create_table :worker_accounts, id: false do |t|
      t.integer :id
      t.boolean :bank, null: false, default: true
      t.boolean :post_bank, null: false, default: false
      t.string :bank_name
      t.string :branch_name
      t.boolean :type, null: false, default: false
      t.string :account_name
      t.string :number

      t.timestamps
    end
    add_index :worker_accounts, :id, unique: true
  end
end

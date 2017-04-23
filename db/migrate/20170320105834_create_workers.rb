class CreateWorkers < ActiveRecord::Migration[5.0]
  def change
    create_table :workers do |t|
      t.string :last_name, null: false
      t.string :first_name, null: false
      t.string :username, null: false
      t.string :email, null: false
      t.string :password_digest, null: false
      t.string :remember_digest
      t.string :activation_digest
      t.boolean :activated, null: false, default: false
      t.datetime :activated_at
      t.string :reset_digest
      t.datetime :reset_sent_at

      t.timestamps
    end
  end
end

class CreateClents < ActiveRecord::Migration[5.0]
  def change
    create_table :clents do |t|
      t.string :last_name, null: false
      t.string :first_name, null: false
      t.string :username, null: false
      t.string :company_name, null: false
      t.string :email, null: false
      t.string :password_digest, null: false

      t.timestamps
    end
  end
end

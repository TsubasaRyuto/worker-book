class CreateClients < ActiveRecord::Migration[5.0]
  def change
    create_table :clients do |t|
      t.string :name, null: false
      t.string :corporate_site, null: false
      t.string :clientname, null: false
      t.integer :location, null: false, default: 0
      t.string :logo, null: false

      t.timestamps
    end
  end
end

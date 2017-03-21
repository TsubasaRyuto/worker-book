class CreateClientProfiles < ActiveRecord::Migration[5.0]
  def change
    create_table :client_profiles, id: false do |t|
      t.integer :id, null: false
      t.string :corporate_site, null: false
      t.string :logo, null: false

      t.timestamps
    end
    add_index :client_profiles, :id, unique: true
  end
end

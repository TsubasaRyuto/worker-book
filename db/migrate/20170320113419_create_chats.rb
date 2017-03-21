class CreateChats < ActiveRecord::Migration[5.0]
  def change
    create_table :chats do |t|
      t.references :agreement, null: false
      t.text :message, null: false

      t.timestamps
    end
  end
end

class CreateChats < ActiveRecord::Migration[5.0]
  def change
    create_table :chats do |t|
      t.references :agreement, null: false
      t.string :sender_username, null: false
      t.string :receiver_username, null: false
      t.text :message, null: false
      t.boolean :read_flg, null: false, default: false

      t.timestamps
    end
  end
end

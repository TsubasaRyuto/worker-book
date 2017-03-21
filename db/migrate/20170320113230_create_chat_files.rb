class CreateChatFiles < ActiveRecord::Migration[5.0]
  def change
    create_table :chat_files do |t|
      t.references :chat, null: false
      t.string :filename, null: false

      t.timestamps
    end
  end
end

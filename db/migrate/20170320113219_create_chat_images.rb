class CreateChatImages < ActiveRecord::Migration[5.0]
  def change
    create_table :chat_images do |t|
      t.references :chat, null: false
      t.string :image, null: false

      t.timestamps
    end
  end
end

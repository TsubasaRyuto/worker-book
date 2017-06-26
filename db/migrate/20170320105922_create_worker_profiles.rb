class CreateWorkerProfiles < ActiveRecord::Migration[5.0]
  def change
    create_table :worker_profiles, id: false do |t|
      t.integer :id, null: false
      t.boolean :type_web_developer, null: false, default: false
      t.boolean :type_mobile_developer, null: false, default: false
      t.boolean :type_game_developer, null: false, default: false
      t.boolean :type_desktop_developer, null: false, default: false
      t.boolean :type_ai_developer, null: false, default: false
      t.boolean :type_qa_testing, null: false, default: false
      t.boolean :type_web_mobile_desiner, null: false, default: false
      t.boolean :type_project_maneger, null: false, default: false
      t.boolean :type_other, null: false, default: false
      t.integer :availability, null: false, default: 0
      t.string :past_performance1, null: false
      t.string :past_performance2
      t.string :past_performance3
      t.string :past_performance4
      t.integer :unit_price, null: false, default: 30_000
      t.text :appeal_note, null: false
      t.string :picture, null: false
      t.string :location, null: false, default: '01'
      t.string :employment_history1, null: false
      t.string :employment_history2
      t.string :employment_history3
      t.string :employment_history4
      t.boolean :currently_freelancer, null: false, default: true
      t.boolean :active, null: false, default: true

      t.timestamps
    end
    add_index :worker_profiles, :id, unique: true
  end
end

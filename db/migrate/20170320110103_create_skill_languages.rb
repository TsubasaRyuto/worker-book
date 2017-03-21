class CreateSkillLanguages < ActiveRecord::Migration[5.0]
  def change
    create_table :skill_languages do |t|
      t.string :name, null: false

      t.timestamps
    end
  end
end

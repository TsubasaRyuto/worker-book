class CreateWorkerSkills < ActiveRecord::Migration[5.0]
  def change
    create_table :worker_skills do |t|
      t.references :worker, null: false
      t.references :skill, null: false

      t.timestamps
    end
  end
end

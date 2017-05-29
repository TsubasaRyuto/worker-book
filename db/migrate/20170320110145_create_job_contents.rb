class CreateJobContents < ActiveRecord::Migration[5.0]
  def change
    create_table :job_contents do |t|
      t.references :client, null: false
      t.string :title, null: false
      t.text :content, null: false
      t.text :note, null: false
      t.datetime :start_date, null: false
      t.datetime :finish_date, null: false
      t.boolean :finished, null: false, default: false

      t.timestamps
    end
  end
end

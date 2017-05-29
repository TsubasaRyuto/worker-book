class CreateJobRequests < ActiveRecord::Migration[5.0]
  def change
    create_table :job_requests do |t|
      t.references :worker, null: false
      t.references :job_content, null: false
      t.string :activation_digest

      t.timestamps
    end
  end
end

class CreateAgreements < ActiveRecord::Migration[5.0]
  def change
    create_table :agreements do |t|
      t.references :worker, null: false
      t.references :job_content, null: false
      t.boolean :active, null: false, default: true

      t.timestamps
    end
  end
end

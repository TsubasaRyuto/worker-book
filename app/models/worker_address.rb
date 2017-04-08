class WorkerAddress < ApplicationRecord
  self.table_name = 'worker_addresses'
  self.primary_key = :id
  belongs_to :worker, foreign_key: 'id'

  before_create { self.id = self.worker.id }
  validates :id, uniqueness: true
end

# == Schema Information
#
# Table name: worker_addresses
#
#  id           :integer          not null, primary key
#  postcode     :string(7)        not null
#  prefecture   :string(2)
#  city         :string(200)
#  house_number :string(200)
#  phone_number :string(13)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_worker_addresses_on_id  (id) UNIQUE
#

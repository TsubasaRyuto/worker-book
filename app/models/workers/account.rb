module Workers
  class Account < ApplicationRecord
    self.table_name = 'worker_accounts'
    self.primary_key = :id
    belongs_to :worker, foreign_key: 'id'

    before_create { self.id = self.worker.id }
    validates :id, uniqueness: true
  end
end

# == Schema Information
#
# Table name: worker_accounts
#
#  id           :integer          primary key
#  bank         :boolean          default(TRUE), not null
#  post_bank    :boolean          default(FALSE), not null
#  bank_name    :string(255)
#  branch_name  :string(255)
#  type         :boolean          default(FALSE), not null
#  account_name :string(255)
#  number       :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_worker_accounts_on_id  (id) UNIQUE
#

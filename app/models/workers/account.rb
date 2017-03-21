module Workers
  class Account < ApplicationRecord
    self.primary_key = :id
    belongs_to :worker, foreign_key: 'id'

    before_create { self.id = self.worker.id }
  end
end

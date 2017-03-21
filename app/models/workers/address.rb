module Workers
  class Address < ApplicationRecord
    self.primary_key = :id
    belongs_to :worker, foreign_key: 'id'

    before_create { self.id = self.worker.id }
    validates :id, uniqueness: true
  end
end

module Clients
  class Profile < ApplicationRecord
    self.primary_key = :id
    belongs_to :clients, foreign_key: 'id'

    before_create { self.id = self.client.id }
    validates :id, uniqueness: true
  end
end

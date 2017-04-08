class ClientProfile < ApplicationRecord
  self.table_name = 'client_profiles'
  self.primary_key = :id
  belongs_to :clients, foreign_key: 'id'

  before_create { self.id = self.client.id }
  validates :id, uniqueness: true
end


# == Schema Information
#
# Table name: client_profiles
#
#  id             :integer          not null, primary key
#  corporate_site :string(255)      not null
#  logo           :string(255)      not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_client_profiles_on_id  (id) UNIQUE
#

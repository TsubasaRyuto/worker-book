class Worker < ApplicationRecord
  has_many :skills, dependent: :destroy, class_name: 'Workers::Skill'
  has_many :agreements
  has_one :account, dependent: :destroy, foreign_key: 'id', class_name: 'Workers::account'
  has_one :address, dependent: :destroy, foreign_key: 'id', class_name: 'Workers::Address'
  has_one :profile, dependent: :destroy, foreign_key: 'id', class_name: 'Workers::profile'

  before_save do
    self.build_account unless self.account
    self.build_address unless self.address
    self.build_profile unless self.profile
  end
end

# == Schema Information
#
# Table name: workers
#
#  id              :integer          not null, primary key
#  last_name       :string(255)      not null
#  first_name      :string(255)      not null
#  username        :string(255)      not null
#  email           :string(255)      not null
#  password_digest :string(255)      not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

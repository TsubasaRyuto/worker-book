class Clent < ApplicationRecord
  has_many :job_contents, dependent: :destroy
  has_one :profile, dependent: :destroy, foreign_key: 'id', class_name: 'Clients::Profile'

  before_save {
    self.build_profile unless self.profile
  }
end

# == Schema Information
#
# Table name: clents
#
#  id              :integer          not null, primary key
#  last_name       :string(255)      not null
#  first_name      :string(255)      not null
#  username        :string(255)      not null
#  company_name    :string(255)      not null
#  email           :string(255)      not null
#  password_digest :string(255)      not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

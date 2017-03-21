module Workers
  class Skill < ApplicationRecord
    belongs_to :worker
    belongs_to :skill_language
  end
end

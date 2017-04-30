class Skill < ActsAsTaggableOn::Tag
  # skills
  scope :autocomplete, ->(term) { where('name collate utf8_unicode_ci LIKE ?', "#{term}%").order(:name) }
end

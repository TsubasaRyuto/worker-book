class Skill < ActsAsTaggableOn::Tag
  # skills
  scope :autocomplete, ->(term) { where('name collate utf8_unicode_ci LIKE ?', "#{term}%").order(:name) }
end

# == Schema Information
#
# Table name: tags
#
#  id             :integer          not null, primary key
#  name           :string(255)
#  taggings_count :integer          default(0)
#
# Indexes
#
#  index_tags_on_name  (name) UNIQUE
#

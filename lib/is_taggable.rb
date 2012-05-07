require 'is_taggable/active_record_extension'
require 'is_taggable/mixin'
require 'is_taggable/tag_list'

module IsTaggable
  def self.configure_tag_list(style = :standard, options = {})
    @style = style
    @options = options

  def self.style
    @style ||= :standard
  end

  def self.options
    @options ||= {}
  end

  def self.create_tag_list(list_or_string)
    tag_list_class = "IsTaggable::TagList::#{style.to_s.capitalize}".constantize
    tag_list_class.new(list_or_string, options)
  end
end

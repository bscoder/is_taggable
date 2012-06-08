require 'is_taggable/model_extension'
require 'is_taggable/mixin'
require 'is_taggable/list'

module IsTaggable
  module ListToolbox
    autoload :Base,     'is_taggable/list_toolbox/base'
    autoload :Standard, 'is_taggable/list_toolbox/standard'
    autoload :Youtube,  'is_taggable/list_toolbox/youtube'
  end

  extend self

  def configure_tag_list(style = :standard, options = {})
    if style.respond_to?(:to_sym)
      @list_toolbox = IsTaggable::ListToolbox.const_get(style.to_sym.capitalize).new(options)
    else
      @list_toolbox = style # suppose the style is a ready-to-use list_toolbox object
    end
  end

  def list_toolbox
    @list_toolbox
  end

  def create_tag_list(list_or_string)
    tag_list_class = "IsTaggable::TagList::#{style.to_s.capitalize}".constantize
    tag_list_class.new(list_or_string, options)
  end
end

ActiveSupport.on_load(:active_record) do
  extend IsTaggable::ModelExtension
end

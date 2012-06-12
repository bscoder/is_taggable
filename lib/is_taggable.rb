require 'active_support'
require 'is_taggable/active_record_extension'

autoload :Tag,     'tag'
autoload :Tagging, 'tagging'

module IsTaggable
  autoload :Mixin,   'is_taggable/mixin'
  autoload :List,    'is_taggable/list'

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
end

ActiveSupport.on_load(:active_record) do
  extend IsTaggable::ActiveRecordExtension
end

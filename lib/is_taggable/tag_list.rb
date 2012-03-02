module IsTaggable
  module TagList
    require 'is_taggable/tag_list/base'
    autoload :Standard, 'is_taggable/tag_list/standard'
    autoload :Youtube,  'is_taggable/tag_list/youtube'
  end
end

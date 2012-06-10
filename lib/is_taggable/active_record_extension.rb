module IsTaggable
  module ActiveRecordExtension
    def is_taggable(*kinds)
      class_attribute :tag_kinds

      kinds = [:tags]  if kinds.empty?
      inherited_kinds = tag_kinds || []
      self.tag_kinds = inherited_kinds | kinds.map(&:to_s).map(&:singularize)

      include IsTaggable::Mixin
    end
  end
end

module IsTaggable
  module ActiveRecordExtension
    def is_taggable(*kinds)
      kinds = (kinds.presence || [:tags]).map(&:to_s).map(&:singularize)

      # dynamically def self.tag_kinds - return current kinds, merged with kinds from super:
      singleton_class.send(:define_method, :tag_kinds) { kinds | [* defined?(super) && super() ] }

      include IsTaggable::Mixin
    end
  end
end

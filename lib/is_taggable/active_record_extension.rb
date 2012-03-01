module IsTaggable
  module ActiveRecordExtension
    def is_taggable(*kinds)
      class_inheritable_accessor :tag_kinds
      self.tag_kinds = kinds.map(&:to_s).map(&:singularize)
      self.tag_kinds << :tag if kinds.empty?

      include IsTaggable::Mixin
    end
  end
end

ActiveRecord::Base.extend(IsTaggable::ActiveRecordExtension)

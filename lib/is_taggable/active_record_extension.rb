module IsTaggable
  module ActiveRecordExtension
    def is_taggable(*kinds)
      class_attribute :tag_kinds

      kinds = [:tags]  if kinds.empty?
      tag_kinds_old = tag_kinds || []
      self.tag_kinds = tag_kinds_old | kinds.map(&:to_s).map(&:singularize)

      include IsTaggable::Mixin
    end
  end
end

ActiveRecord::Base.extend(IsTaggable::ActiveRecordExtension)

require 'tag'
require 'tagging'

module IsTaggable
  module Mixin
    def self.included(klass)
      klass.class_eval do
        include InstanceMethods

        has_many   :taggings, :as      => :taggable, :dependent => :destroy
        has_many   :tags,     :through => :taggings
        after_save :save_tags

        tag_kinds.each do |k|
          define_method("#{k}_list")  { get_tag_list(k) }
          define_method("#{k}_list=") { |new_list| set_tag_list(k, new_list) }
        end
      end
    end

    module InstanceMethods
      def set_tag_list(kind, list)
        tag_list = IsTaggable.create_tag_list(list)
        instance_variable_set(tag_list_name_for_kind(kind), tag_list)
      end

      def get_tag_list(kind)
        set_tag_list(kind, tags.of_kind(kind).map(&:name)) if tag_list_instance_variable(kind).nil?
        tag_list_instance_variable(kind)
      end

      protected

        def tag_list_name_for_kind(kind)
          "@#{kind}_list"
        end
        
        def tag_list_instance_variable(kind)
          instance_variable_get(tag_list_name_for_kind(kind))
        end

        def save_tags
          tag_kinds.each do |tag_kind|
            delete_unused_tags(tag_kind)
            add_new_tags(tag_kind)
          end

          taggings.each(&:save)
        end
        
        def delete_unused_tags(tag_kind)
          tags.of_kind(tag_kind).each { |t| tags.delete(t) unless get_tag_list(tag_kind).include?(t.name) }
        end

        def add_new_tags(tag_kind)
          get_tag_list(tag_kind).each do |tag_name| 
            # Let Tag normalize the tag name.
            tag = Tag.find_or_initialize_with_name_like_and_kind(tag_name, tag_kind)
            tags << tag unless tags.include?(tag)
          end
          # BUGGY Remember the normalized tag names.
          # set_tag_list(tag_kind, tags.of_kind(tag_kind).map(&:name))
        end
    end
  end
end

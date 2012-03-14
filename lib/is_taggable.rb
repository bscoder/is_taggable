path = File.expand_path(File.dirname(__FILE__))
$LOAD_PATH << path unless $LOAD_PATH.include?(path)
require 'tag'
require 'tagging'

module IsTaggable
  class TagList < Array
    cattr_accessor :delimiter, :output_delimiter
    @@delimiter = ','
    
    def initialize(list)
      list = list.is_a?(Array) ? list : split_tags(list)
      super
    end

    def split_tags(list)
      swt = list
      mwt = list.scan(/"[^"]+?"/)
      mwt.each {|v| swt = swt.gsub(v,' ')} 
      result = (swt.split(/,|\s/)+mwt).map{|v| v.gsub(/[^\'\w\s\-,]/,'').downcase}
      result.reject{|i| (i.blank? || i.size < 2)}
    end
    
    def to_s
      map{|v| v.match(/\s|,/) ? '"' + v + '"' : v}.join(@@output_delimiter || @@delimiter)
    end
  end

  module ActiveRecordExtension
    def is_taggable(*kinds)
      class_inheritable_accessor :tag_kinds
      self.tag_kinds = kinds.map(&:to_s).map(&:singularize)
      self.tag_kinds << :tag if kinds.empty?

      include IsTaggable::TaggableMethods
    end
  end

  module TaggableMethods
    def self.included(klass)
      klass.class_eval do
        include IsTaggable::TaggableMethods::InstanceMethods

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
        tag_list = TagList.new(list)
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

ActiveRecord::Base.send(:extend, IsTaggable::ActiveRecordExtension)

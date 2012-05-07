module IsTaggable::TagList
  class Base < Array
    def initialize(tags, options)
      set_options(options)

      if tags.is_a?(Array)
        list = tags
      else
        list = split_tags(tags).map{ |t| normalize_tag(t) }.reject{ |t| reject_tag(t) }
      end

      super(list.uniq)
    end

    def to_s
      join_tags(self)
    end

    protected

    def set_options(options)
    end

    def split_tags(str)
      str.split(' ')
    end

    def normalize_tag(tag)
      tag
    end

    def reject_tag(tag)
      false
    end

    def join_tags(list)
      list.join(' ')
    end
  end
end

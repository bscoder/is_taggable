module IsTaggable::TagList
  class Standard < Base
    protected

    def set_options(options)
      @delimiter = options[:delimiter] || ' '
      @output_delimiter = options[:output_delimiter] || nil
    end

    def split_tags(str)
      str.split(@delimiter)
    end

    def normalize_tag(tag)
      tag.strip.gsub(/\s+/, ' ')
    end

    def reject_tag(tag)
      tag.blank?
    end

    def join_tags(list)
      list.join(@output_delimiter || @delimiter)
    end
  end
end

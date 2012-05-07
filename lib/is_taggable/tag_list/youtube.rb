module IsTaggable::TagList
  class Youtube < Base
    protected

    def split_tags(str)
      if str.index(',') != nil   # commas?
        result = str.split(',')  # - split by 'em
      elsif str.index('"') != nil  # quotation marks?
        quoted_tag_list = str.scan(/"[^"]+?"/)
        quoted_tag_list.each {|v| str.gsub!(v, '') }
        quoted_tag_list.each {|v| v.gsub!('"', '') }
        result = (str.split(' ') + quoted_tag_list)
      else
        result = str.split(' ')  # split by spaces
      end
    end

    def normalize_tag(tag)
      tag.strip.gsub(/\s+/ , ' ').delete('"')
    end

    def reject_tag(tag)
      tag.size < 2
    end

    def join_tags(list)
      list.map{|t| t.index(' ') ? "\"#{t}\"" : t}.join(' ')
    end
  end
end


module IsTaggable::ListToolbox

  class Youtube < Base
    def extract(str)
      if str.index(',') != nil  # commas? - split by 'em
        result = str.split(',') 
      else                      # split by spaces, but preserve quoted sequences
        quoted_tag_list = str.scan(/"[^"]+?"/)
        quoted_tag_list.each { |substr| str.gsub!(substr, '') }
        result = (str.split(' ') + quoted_tag_list)
      end
    end

    def join(list)
      list.map{ |t| t.index(' ') ? "\"#{t}\"" : t }.join(' ')
    end

    def normalize(tag)
      super(tag.delete(?"))
    end

    def valid?(tag)
      super && tag.size > 1
    end
  end

end

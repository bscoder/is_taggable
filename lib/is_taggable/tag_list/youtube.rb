module IsTaggable::TagList
  class Youtube < Base
    protected

    def split_tags(str)
      if str.index(',') != nil # если запятые есть
        result = str.split(',') # разделяем по ним
      else
        if str.index('"') != nil  # если есть кавычки.
          quoted_tag_list = str.gsub('"', '').scan(/"[^"]+?"/) #выделяем квотированные теги 
          ququoted_tag_list.each{ |v| v.gsub!('"', '').strip!} #удаляем кавычки
          quoted_tag_list.each {|v| str.gsub!(v, '')} # удаляем все квотированные теги
          result = (str.split(' ') + quoted_tag_list) #собираем список обратно
        else
          result = str.split(' ') # если ни запятых ни кавычек нет, разделяем просто по пробелам      
        end
      end
    end

    def normalize_tag(tag)
      tag.strip.gsub(/\s+/ , ' ')
    end

    def reject_tag(tag)
      tag.size<2
    end

    def join_tags(list)
      list.map{|t| t.index(' ') ? "\"#{t}\"" : t}
    end
  end
end


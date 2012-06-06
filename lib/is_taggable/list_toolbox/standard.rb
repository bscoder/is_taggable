module IsTaggable::ListToolbox

  class Standard < Base
    attr_reader :delimiter
    attr_reader :output_delimiter

    def initialize(options = {})
      @delimiter = options.delete(:delimiter) || ' '
      @output_delimiter = options.delete(:output_delimiter) || @delimiter
      super(options)
    end

    def extract(str)
      str.split(@delimiter)
    end

    def join(tags)
      tags.join(@output_delimiter)
    end
  end

end

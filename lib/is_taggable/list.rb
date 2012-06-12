module IsTaggable

  class List < Array
    def initialize(list, toolbox = nil)
      @tools = toolbox || ListToolbox::Standard.new
      super(list)
    end

    def to_s
      @tools.join(self)
    end

    def normalize_tags!
      normalized = self.map { |item| item.frozen? ? item : extract_tags(item.to_s) }.flatten.uniq
      self.clear.push(*normalized)
    end

    def freeze_tags!
      self.each { |item| item.freeze }
    end

    private

    def extract_tags(str)
      @tools.extract(str).map{ |tag| @tools.normalize(tag).freeze }.select{ |tag| @tools.valid?(tag) }
    end
  end

end

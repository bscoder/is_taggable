module IsTaggable::ListToolbox
  class Base
    attr_reader :extra_normalizer
    attr_reader :extra_validator

    def initialize(options = {})
      @extra_normalizer = options.delete(:normalize_with).to_proc  if options[:normalize_with]
      @extra_validator = options.delete(:valid_when).to_proc  if options[:valid_when]

      raise ArgumentError.new("Wrong parameters for #{self.class.name}#initialize call: #{options}")  unless options.empty?
    end

    # kind of no-op extractor, to be overridden in subclass
    def extract(str)
      [str]
    end

    # NOTE: don't override this in a subclass - work with #prenormalize method instead
    def normalize(tag)
      prenormalized = prenormalize(tag)
      @extra_normalizer ? @extra_normalizer.call(prenormalized) : prenormalized
    end

    # NOTE: don't override this in a subclass - work with #prevalidated? method instead
    def valid?(tag)
      prevalidated = prevalidated?(tag)
      @extra_validator ? @extra_validator.call(tag) && prevalidated : prevalidated
    end

    def join(tags)
      tags.join(' ')
    end

    protected

    def prenormalize(tag)
      tag.strip.gsub(/\s+/, ' ')
    end

    def prevalidated?(tag)
      ! tag.nil? && tag != ''
    end
  end
end

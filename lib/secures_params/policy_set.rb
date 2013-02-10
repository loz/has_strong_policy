class SecuresParams::PolicySet
  def initialize
    @definitions = Hash.new do |h,k|
      h[k] = SecuresParams::PolicyDefinition.new
    end
  end

  def with_condition(condition)
    d = @definitions[condition]
    proxy = Proxy.new(condition, self, d)
    yield proxy if block_given?
    proxy
  end

  class Proxy
    attr_reader :conditions, :set, :definition

    def initialize(conditions, set, definition)
      @conditions = conditions
      @definition = definition
      @set = set
    end

    def apply(*args)
      definition.apply(*args)
    end

    def required(*args)
      definition.required(*args)
    end

    def permitted(*args)
      definition.permitted(*args)
    end

    def with_condition(condition, &block)
     set.with_condition(conditions.merge(condition), &block)
    end
  end

end
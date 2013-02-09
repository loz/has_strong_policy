class SecuresParams::Policy
  def self.inherited(base)
    base.instance_variable_set("@policy_set", PolicySet.new)
  end

  def self.required(required)
    @policy_set.required(required)
  end

  def self.permitted(*keys)
    @policy_set.permitted(*keys)
  end

  def self.apply_policy(params)
    @policy_set.apply(params)
  end

  def initialize(params)
    @params = params
  end

  def secured
    self.class.apply_policy(@params)
  end

  class PolicySet
    def initialize
      @required = nil
      @permitted = []
    end

    def required(required)
      @required = required
    end

    def permitted(*keys)
      @permitted = keys
    end

    def apply(params)
      applied = params
      applied = applied.require(@required) if @required
      applied = applied.permit(*@permitted) if @permitted
      applied
    end
  end
end

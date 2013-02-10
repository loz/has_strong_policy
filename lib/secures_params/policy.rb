class SecuresParams::Policy
  def self.inherited(base)
    base.instance_eval do
      @policy_set = SecuresParams::PolicySet.new

      def policy_set
        @policy_set
      end
    end
  end

  def self.required(required)
    policy_set.with_condition({}).required(required)
  end

  def self.permitted(*keys)
    policy_set.with_condition({}).permitted(*keys)
  end

  def self.on(action)
    policy_set.with_condition({:action => action}) do |definition|
      yield definition
    end
  end

  def secured(params)
    conditions = build_conditions(params)
    self.class.policy_set.with_condition(conditions).apply(params)
  end

  private

  def build_conditions(params)
    conditions = {}
    conditions[:action] = params[:action] if params[:action]
    conditions
  end

end

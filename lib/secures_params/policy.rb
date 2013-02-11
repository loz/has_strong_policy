class SecuresParams::Policy
  def self.inherited(base)
    base.instance_eval do
      @policy_set = SecuresParams::PolicySet.new

      def policy_set
        @policy_set
      end
    end
  end

  def self.policy(&block)
    policy_set.with_condition({},nil,&block)
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

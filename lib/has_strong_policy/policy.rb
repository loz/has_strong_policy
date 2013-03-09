class HasStrongPolicy::Policy
  def self.inherited(base)
    base.instance_eval do
      @policy_set = HasStrongPolicy::PolicySet.new

      def policy_set
        @policy_set
      end
    end
  end

  def self.policy(&block)
    policy_set.with_condition({},nil,&block)
  end

  def apply(params, options = {})
    conditions = build_conditions(params, options)
    self.class.policy_set.with_condition(conditions).apply(params, options)
  end

  private

  def build_conditions(params, options)
    conditions = {}
    conditions[:action] = params[:action] if params[:action]
    conditions[:as] = options[:as] if options[:as]
    conditions
  end

end

class SecuresParams::Policy
  def self.inherited(base)
    sets = {}
    base.instance_variable_set("@scope_stack", [])
    base.instance_variable_set("@policy_sets", sets)
    sets[[]] = SecuresParams::PolicyDefinition.new
  end

  def self.scoped_policy(scope)
    @policy_sets[scope]
  end

  def self.required(required)
    scoped_policy(@scope_stack).required(required)
  end

  def self.permitted(*keys)
    scoped_policy(@scope_stack).permitted(*keys)
  end

  def self.apply_policy(params)
    scope = []
    scope << {:action => params[:action]} if params[:action]
    policy = scoped_policy(scope) || scoped_policy([])
    policy.apply(params)
  end

  def self.on(action)
    current_policy = scoped_policy(@scope_stack)
    @scope_stack = @scope_stack + [{:action => action}]
    @policy_sets[@scope_stack] ||= inherit_definition(current_policy)
    yield
    @scope_stack = @scope_stack[0..-2]
  end

  def self.inherit_definition(current)
    SecuresParams::PolicyDefinition.new.tap do |pd|
      pd.required current.get_required
      pd.permitted current.get_permitted.dup
    end
  end

  def secured(params)
    self.class.apply_policy(params)
  end

end

class SecuresParams::PolicyDefinition
  def required(required)
    @required = required
  end

  def get_required
    @required
  end

  def permitted(*keys)
    @permitted ||= []
    @permitted += keys
    @permitted.flatten!
  end

  def get_permitted
    @permitted
  end

  def apply(params)
    applied = params
    applied = applied.require(@required) if @required
    applied = applied.permit(*@permitted) if @permitted
    applied
  end
end

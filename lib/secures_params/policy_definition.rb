class SecuresParams::PolicyDefinition
  def required(required)
    @required = required
  end

  def permitted(*keys)
    @permitted ||= []
    @permitted += keys
    @permitted.flatten!
  end

  def extend_from(target)
    @required = target.get_required
    @permitted = target.get_permitted
  end

  def apply(params, options = {})
    applied = params
    applied = applied.require(@required) if @required
    applied = applied.permit(*@permitted) if @permitted
    applied
  end

  protected

  def get_permitted
    @permitted
  end

  def get_required
    @required
  end

end

class MockStrongParams
  #For Test
  attr_writer :permitted
  def initialize(params = {})
    @params = params
  end

  def [](key)
    @params[key]
  end

  def []=(key, value)
    @params[key] = value
  end

  def to_hash
    @params
  end

  #API
  def require(key)
    found = @params.fetch(key) { raise 'RequiredMissing' }
    self.class.new found
  end

  def permit(*keys)
    permitted = self.class.new(@params.select {|k,v| keys.include? k})
    permitted.permitted = true
    permitted
  end

  def permitted?
    @permitted
  end
end


require 'active_support/core_ext'

module HasStrongPolicy::ControllerHelper
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def has_strong_policy(options = {})
      include HasStrongPolicy::ControllerHelper::HasHasStrongPolicy
      @_policy_class = options[:using]
    end
  end

  module HasHasStrongPolicy
    def self.included(base)
      base.extend ClassMethods
    end

    def policy_params
      self.class.policy_class.new(params).apply
    end

    module ClassMethods
      def policy_class
        return @_policy_class if @_policy_class
        name = self.name.gsub(/Controller/, '') + 'ParamsPolicy'
        @_policy_class = name.constantize
      end
    end

  end
end

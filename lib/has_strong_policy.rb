require "has_strong_policy/version"

module HasStrongPolicy
  autoload :ControllerHelper, 'has_strong_policy/controller_helper'
  autoload :Policy, 'has_strong_policy/policy'
  autoload :PolicyDefinition, 'has_strong_policy/policy_definition'
  autoload :PolicySet, 'has_strong_policy/policy_set'
end

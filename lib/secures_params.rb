require "secures_params/version"

module SecuresParams
  autoload :ControllerHelper, 'secures_params/controller_helper'
  autoload :Policy, 'secures_params/policy'
  autoload :PolicyDefinition, 'secures_params/policy_definition'
end

require 'active_support/core_ext'

module SecuresParams::ControllerHelper
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods
    def secures_params
      include SecuresParams::ControllerHelper::HasSecuresParams
    end
  end

  module HasSecuresParams
    def self.included(base)
      base.extend ClassMethods
    end

    def secured_params
      self.class.securing_class.new(params).secured
    end

    module ClassMethods
      def securing_class
        name = self.name.gsub(/Controller/, '') + 'ParamsSecurer'
        name.constantize
      end
    end

  end
end

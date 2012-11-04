require 'presenta/version'

module Presenta
  def self.included(base)
    base.send :extend, Extensions
    base.send :include, Inclusions
    base.send :include, Primitives
  end

  module Inclusions
    def initialize(entity)
      @entity = entity
    end

    def entity
      @entity
    end
  end

  module Extensions
    def subject(name)
      define_method name do
        entity
      end
    end

    def present(name, type = Presenta::Primitives::Value, attribute = name)
      define_method name do
        value = entity.send(attribute) if entity
        value = type.new(value) unless type == Presenta::Primitives::Value
        value
      end
    end
  end

  module Primitives
    class Value
    end
  end
end

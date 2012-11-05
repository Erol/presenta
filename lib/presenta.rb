require 'presenta/version'

require 'facets/kernel/constant'

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

    def present(name, type = Presenta::Primitives::Value, attribute = nil, &block)
      if attribute && block
        raise ArgumentError, 'attribute and block cannot be passed both'
      end

      type = constant(type) if type.is_a? Symbol

      attribute ||= name

      define_method name do
        value = if block
                  instance_eval(&block)
                else
                  entity.send(attribute) if entity
                end

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

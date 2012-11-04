require 'presenta/version'

module Presenta
  def self.included(base)
    base.send :extend, Extensions
    base.send :include, Inclusions
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

    def present(name)
      define_method name do
        entity.send(name) if entity
      end
    end
  end
end

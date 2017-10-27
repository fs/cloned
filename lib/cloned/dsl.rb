module Cloned
  module DSL
    attr_reader :associations

    def before(&block)
      define_method :declared_before, &block
    end

    def after(&block)
      define_method :declared_after, &block
    end

    def nullify(*attributes)
      define_method :clearing_attributes do
        attributes
      end
    end

    def association(association_id, options = {})
      associations[association_id] = options
    end

    def associations
      @associations ||= {}
    end
  end
end

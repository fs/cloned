module Cloned
  module DSL
    def before(&block)
      define_method :declared_before, &block
    end

    def after(&block)
      define_method :declared_after, &block
    end

    def nullify(*attributes)
      clearing_attributes.push(*attributes)
    end

    def association(association_id, options = {})
      associations[association_id] = options
    end

    def associations
      @associations ||= {}
    end

    def clearing_attributes
      @clearing_attributes ||= []
    end
  end
end

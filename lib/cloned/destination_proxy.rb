module Cloned
  class DestinationProxy
    def initialize(owner, association)
      @owner = owner
      @association = association
    end

    def concat(clon)
      if @owner.class.reflections[@association.to_s].is_a?(ActiveRecord::Reflection::HasManyReflection)
        @owner.public_send(@association).concat(clon)
      else
        @owner.public_send("#{@association}=", clon)
      end
    end
  end
end

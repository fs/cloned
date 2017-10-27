class Cloned::Strategy
  class << self
    def cloners_map
      @cloners_map ||= {}
    end

    def declare(cloner_id, options = {}, &block)
      cloner_name = options[:class_name] || cloner_id.to_s.camelcase
      cloner = Class.new(Cloned::Base, &block)
      cloner.strategy = self
      cloners_map[cloner_name] = cloner
    end

    def find_copier(klass)
      cloners_map[klass.name] || Cloned::Base
    end

    def make(target, destination, options = {})
      find_copier(target.class).new(target, destination, options).make
    end

    def create(target, destination, options = {})
      make(target, destination, options.merge(force: true))
    end
  end
end

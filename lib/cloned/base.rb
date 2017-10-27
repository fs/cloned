require 'cloned/dsl'

module Cloned
  class Base
    attr_reader :copy, :target, :destination, :options
    delegate :strategy, to: :class

    def initialize(target, destination, options = {})
      @target = target
      @destination = destination
      @options = options
    end

    def make
      if skip_transaction?
        make_or_fail!
      else
        ActiveRecord::Base.transaction { make_or_fail! }
      end
      copy
    end

    def valid?
      target.presence
    end

    protected

    def skip_transaction?
      options[:skip_transaction]
    end

    def force?
      options[:force].presence
    end

    def optional_before(clon)
      options[:before].call(clon) if options.key?(:before)
    end

    def optional_after(clon)
      options[:after].call(clon) if options.key?(:after)
    end

    class << self
      attr_accessor :strategy

      include Cloned::DSL

      delegate :find_copier, to: :strategy
    end

    private

    def copy_association(target_association:, destination:, **options)
      copier = strategy.find_copier(target_association.proxy_association.klass)
      target_association.each do |target_item|
        copier.new(target_item, destination, options.merge(skip_transaction: true)).make
      end
    end

    def copy_associations(clon)
      self.class.associations.each do |association_id, options|
        copy_association(
          target_association: target.public_send(association_id),
          destination: clon.public_send(association_id),
          **options)
      end
    end

    def clearing_attributes
      []
    end

    def before(clon)
      optional_before(clon)
      declared_before(clon) if respond_to?(:declared_before)
    end

    def after(clon)
      optional_after(clon)
      declared_after(clon) if respond_to?(:declared_after)
    end

    def prepare(clon)
      clon.assign_attributes(Hash[clearing_attributes.map { |k| [k, nil] }])
      clon
    end

    def validate!
      raise 'Cloning context not valid!' unless valid?
    end

    def make_or_fail!
      validate!
      return if options.key?(:if) && !options[:if].call(target)
      @copy = make_copy(target: target, destination: destination)
      @copy.save! if force?
    end

    def make_copy(target:, destination:)
      clon = prepare(target.dup)
      before(clon)
      destination.concat(clon) unless destination.nil?
      copy_associations(clon)
      after(clon)
      clon
    end
  end
end

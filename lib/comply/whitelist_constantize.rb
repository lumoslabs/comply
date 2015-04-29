require 'active_model/validations'

module Comply
  module WhitelistConstantize

    class MatcherFactory
      attr_reader :obj, :options
      def initialize(obj, options = {})
        @obj     = obj
        @options = options
      end

      def to_matcher
        if obj.is_a?(Module) && options[:include_inheritance]
          procify_module
        else
          obj
        end
      end

      private

      def procify_module
        -> (klass) { klass <= obj }
      end
    end

    class NotWhitelistedError < ArgumentError
    end

    class << self
      DEFAULT_PROC = MatcherFactory.new(ActiveModel::Validations, include_inheritance: true).to_matcher

      def constantize(str)
        whitelist!(str.classify.constantize)
      end

      def whitelist
        @whitelist ||= [DEFAULT_PROC]
      end

      # obj can be a Class, Module or Proc.
      # For classes and modules, optionally add `include_inheritance: true` to
      # also match subclasses.
      # Procs should accept one argument.
      def allow(obj, opts = {})
        whitelist << MatcherFactory.new(obj, opts).to_matcher
      end

      private

      def whitelist!(obj)
        obj.tap do |klass|
          whitelist.detect(-> { raise NotWhitelistedError }) do |matcher|
            matcher === klass || matcher == klass
          end
        end
      end
    end

  end
end

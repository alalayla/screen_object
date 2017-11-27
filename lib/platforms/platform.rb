module ScreenObject
  module Platforms
    class Platform
      def initialize(name)
        @name = name.to_sym
      end

      attr_reader :name
    end
  end
end
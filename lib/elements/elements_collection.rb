module ScreenObject
  module Elements
    class ElementsCollection
      include Enumerable

      def initialize(identifiers, platform)
        locator = identifiers.is_a?(String) ? identifiers : identifiers[platform.name]
        @locator = locator
        @platform = platform
        @members = @platform.query(@locator) # maybe allow it to be empty if elements are not visible yet
        @elements = @members.map do |m|
          element_locator = @locator + ' ' + "index:#{@members.index(m)}"
          ScreenObject::Elements::Element.new(element_locator, @platform)
        end
      end

      def each(&block)
        @elements.each(&block)
      end

      def [](index)
        @elements[index]
      end
    end
  end
end
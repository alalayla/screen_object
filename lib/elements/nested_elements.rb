require_relative 'elements_collection'

module ScreenObject
  module Elements
    module NestedElements

      def nested_elements(identifiers)
        locator = identifiers.is_a?(String) ? identifiers : identifiers[@platform.name]

        child_loc = @locator + ' ' + locator
        ElementsCollection.new(child_loc, @platform)
      end
    end
  end
end
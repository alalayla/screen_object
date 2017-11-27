require_relative '../elements/element'
require_relative '../finders'

module ScreenObject
  module Sections
    class ScreenSection < Elements::Element
      extend ScreenObject::Finders
      extend ScreenObject::Sections::SectionFinders

      def get_element_for(identifiers)
        nested_element(identifiers)
      end

      def get_elements_for(identifiers)
        nested_elements(identifiers)
      end
    end
  end
end

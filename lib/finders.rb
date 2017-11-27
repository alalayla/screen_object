# require_relative 'elements/elements_collection'
# require_relative 'sections/section_finders'
# require_relative 'sections/screen_section'
# require_relative 'sections/sections_collection'

module ScreenObject
  module Finders

    def element(name, identifiers)
      define_method("#{name}_element") do
        get_element_for(identifiers)
      end

      define_method(name) do |&block|
        get_element_for(identifiers).touch
      end

      define_method("#{name}?") do
        get_element_for(identifiers).visible?
      end

      define_method("#{name}=") do |value|
        get_element_for(identifiers).enter_text(value)
      end
    end

    def elements(name, identifiers)
      define_method("#{name}_elements") do
        get_elements_for(identifiers)
      end
    end
  end
end
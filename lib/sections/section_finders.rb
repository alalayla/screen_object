require_relative '../elements/elements_collection'
require_relative 'sections_collection'

module ScreenObject
  module Sections
    module SectionFinders
      def screen_section(name, section_class, identifiers)
        define_method(name) do
          new_identifiers = identifiers.clone
          # if @locator
          new_identifiers.each_pair do |k, locator|
            new_identifiers[k] = if locator.start_with?('root ')
                                   locator[5..-1]
                                 elsif @locator
                                   locator.empty? ? @locator : ( @locator + ' descendant ' + locator)
                                 else
                                   locator
                                 end
          end
          # end
          section_class.new(new_identifiers, platform)
        end

        define_method("#{name}_element") do
          get_element_for(identifiers)
        end

        define_method("#{name}?") do
          get_element_for(identifiers).visible?
        end

      end

      def screen_sections(name, section_class, identifiers)
        define_method(name) do
          sections_ary = ScreenObject::Elements::ElementsCollection.new(identifiers, platform).map do |elt|
            section_class.new(elt.locator, platform)
          end
          ScreenObject::Sections::SectionsCollection[*sections_ary]
        end
      end
    end
  end
end
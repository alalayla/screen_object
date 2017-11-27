if ENV['PLATFORM'] == 'ios'
  require 'calabash-cucumber/cucumber'
  require_relative 'platforms/i_platform'
elsif ENV['PLATFORM'] == 'android'
  require 'calabash-android/cucumber'
  require_relative 'platforms/a_platform'
end

require_relative 'elements/element'

module ScreenObject
  module HelperMethods

    def android?
      ENV['PLATFORM'] == 'android'
    end

    def ios?
      ENV['PLATFORM'] == 'ios'
    end

    def platform
      @platform = (@plf || get_platform)
    end

    def get_element_for(identifiers)
      ScreenObject::Elements::Element.new(identifiers, platform)
    end

    def get_elements_for(identifiers)
      ScreenObject::Elements::ElementsCollection.new(identifiers, platform)
    end

    def get_platform
      if android?
        ScreenObject::Platforms::APlatform.new(:android)
      elsif ios?
        ScreenObject::Platforms::IPlatform.new(:ios)
      else
        raise "Wrong platform environment variable been found #{ENV['PLATFORM']}"
      end
    end

    def default_wait_time
      ScreenObject::DEFAULT_WAIT_TIME || 30
    end

    def wait_for(wait_time = default_wait_time)
      start_time = Time.now
      loop do
        return true if yield
        break unless (Time.now - start_time) < wait_time
        sleep 0.5
      end
      raise Timeout::Error, 'Timed out while waiting for block to return true'
    end
  end
end
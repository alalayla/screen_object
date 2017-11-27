module ScreenObject

  require_relative 'lib/helper_methods'
  require_relative 'lib/finders'
  require_relative 'lib/sections/section_finders'
  require_relative 'lib/sections/screen_section'
  require_relative 'lib/sections/sections_collection'
  require_relative 'lib/screen_factory'

  DEFAULT_WAIT_TIME = 30

  def initialize(platform = nil)
    @plf = platform
    @platform = (@plf || get_platform)
  end

  def self.included(cls)
    cls.include ScreenObject::HelperMethods
    cls.extend ScreenObject::Finders
    cls.extend ScreenObject::Sections::SectionFinders
  end
end
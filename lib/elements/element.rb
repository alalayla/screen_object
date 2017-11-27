module ScreenObject
  module Elements
    class Element

      attr_reader :locator, :platform

      def initialize(identifiers, platform)
        locator = identifiers.is_a?(String) ? identifiers : identifiers[platform.name]
        @locator = locator
        @platform = platform
      end

      def scroll(direction)
        @platform.scroll(@locator, direction)
      end

      def fast_scroll(direction)
        @platform.fast_scroll(@locator, direction)
      end

      def scroll_list_down
        @platform.scroll_list_down @locator
      end

      def swipe direction
        @platform.send("swipe_#{direction}", @locator)
      end

      def drag_and_drop(direction)
        @platform.send("drag_and_drop_#{direction}", @locator, parent_locator)
      end

      def drag_and_drop_to(element_to)
        @platform.drag_and_drop_to(@locator, element_to.locator)
      end

      def swipe_left
        @platform.swipe_left(@locator)
      end

      def left_to_edge
        @platform.left_to_edge(@locator)
      end

      def swipe_right
        @platform.swipe_right(@locator)
      end

      def swipe_down
        @platform.swipe_down(@locator)
      end

      def swipe_up
        @platform.swipe_up(@locator)
      end

      def nested_element(identifiers)
        locator = identifiers.is_a?(String) ? identifiers : identifiers[platform.name]
        child_loc = if locator.start_with?('root ')
                      locator[5..-1]
                    elsif locator.empty?
                      @locator
                    else
                      @locator + ' descendant ' + locator
                    end
        Element.new(child_loc, @platform)
      end

      def when_visible(skip_tutorials:false, wait_time:30)
        wait_for(skip_tutorials:skip_tutorials, wait_time: wait_time) { visible? }
        self
      end

      def when_not_visible(skip_tutorials:false)
        wait_for(skip_tutorials:skip_tutorials) { !visible? }
      end

      def default_wait_time
        ScreenObject::DEFAULT_WAIT_TIME || 30
      end

      def wait_for(wait_time: default_wait_time)
        start_time = Time.now
        loop do
          return true if yield
          break unless (Time.now - start_time) < wait_time
          sleep 0.5
        end
      end

      def enter_text text
        raise 'Text value is nil' if text.nil?
        @platform.platform_enter_text(@locator, text)
      end

      def clear
        @platform.query(@locator, :setText => '')
      end

      def touch(skip_tutorials:false)
        when_visible(skip_tutorials: skip_tutorials)
        @platform.touch(@locator)
      end

      def long_press
        when_visible
        @platform.long_touch(@locator)
      end

      def text
        get_parameter 'text'
      end

      def value
        get_parameter 'value'
      end

      def parent
        self.class.new(parent_locator, @platform)
      end

      def visible?
        @platform.element_exists(@locator)
      end

      def active?
        get_parameter 'enabled'
      end

      def scroll_into_view
        raise 'Does not work yet'
      end

      def size
        rect = get_element['rect']
        height = rect['height']
        width = rect['width']
        {height: height, width: width}
      end

      def empty?
        get_element.nil?
      end

      #android only
      def selected?
        @platform.query(@locator, :selected).first
      end

      #android only
      def checked?
        @platform.query(@locator, :checked).first
      end

      def count
        @platform.query(@locator).count
      end

      def get_parameter(param)
        get_element[param]
      end

      require_relative 'nested_elements'
      include NestedElements

      private
      def get_element
        @platform.query(@locator).first
      end

      def parent_locator
        @locator + ' parent * index:0'
      end
    end

  end
end
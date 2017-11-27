require_relative 'platform'

module ScreenObject
  module Platforms
    class IPlatform < Platform
      include Calabash::Cucumber::Operations if ENV['PLATFORM'] == 'ios'

      def backdoors(name, params)
        send('backdoor', "#{name}:", params)
      end

      def press_enter
        ios11 = ios_version.to_s.include?('11')
        (ios10?||ios11) ? tap_keyboard_action_key : uia_enter
      end

      def swipe_left(section)
        pan_coordinates(right_edge(section), left_edge(section))
      end

      def rotate_screen(orientation)
        unless send("#{orientation}?")
          orientation.to_sym == :landscape ? rotate(:right) : rotate(:left)
        end
      end

      def swipe_right(section)
        pan_coordinates(left_edge(section), right_edge(section))
      end

      def swipe_down(section)
        swipe :down, {:query => section, :force => :strong}
      end

      def swipe_up(section)
        swipe :up, {:query => section, :force => :strong}
      end

      def drag_and_drop_left(query, section)
        pan_coordinates(center_coord(query), left_edge(section, zero=true))
      end

      def drag_and_drop_right(query, section)
        pan_coordinates(center_coord(query), right_edge(section, zero=true))
      end

      def drag_and_drop_to(query, query_to)
        pan_coordinates(center_coord(query), center_coord(query_to))
      end

      def fast_scroll(query, direction)
        scroll(query, direction)
      end

      def left_edge(section, zero=nil)
        rect = query(section).first['rect']
        x = zero ? 0 : (rect['width']*0.25 + rect['x'])
        {x:x, y:rect['center_y']}
      end

      def right_edge(section,  zero=nil)
        rect = query(section).first['rect']
        x = zero ? (rect['width']+ rect['x']) : (rect['width']*0.9 + rect['x'])
        {x:x, y:rect['center_y']}
      end

      def center_coord(section)
        rect = query(section).first['rect']
        {x:rect['center_x'], y:rect['center_y']}
      end

      def scroll_list_down(section)
        scroll(section, :down)
      end

      def platform_enter_text(query, text)
        ios11 = ios_version.to_s.include?('11')
        touch query
        ios11 ? enter_text(query, text) : keyboard_enter_text(text)
      end

      def long_touch(query, options = {})
        touch_hold(query, options)
      end
    end
  end
end
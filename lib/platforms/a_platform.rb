require_relative 'platform'

module ScreenObject
  module Platforms
    class APlatform < Platform
      include Calabash::Android::Operations if ENV['PLATFORM'] == 'android'

      def backdoors(name, params)
        send('backdoor', name, params)
      end

      def press_enter
        press_enter_button
      end

      def platform_enter_text query, text
        enter_text query, text
      end

      def get_orientation
        get_activity_orientation['message'].to_sym
      end

      def rotate_screen(orientation)
        set_activity_orientation orientation.to_sym unless get_orientation == orientation.to_sym
      end

      def swipe_left(element)
        pan(element, :left, from: {x: 90, y: 50}, to: {x: 10, y: 50})
      end

      def left_to_edge(element)
        pan(element, :left, from: {x: 90, y: 50}, to: {x: 0, y: 50})
      end

      def swipe_right(element)
        pan(element, :right, from: {x: 10, y: 50}, to: {x: 90, y: 50})
      end

      def swipe_down(element)
        pan(element, :down, from: {x: 50, y: 10}, to: {x: 50, y: 90})
      end

      def swipe_up(element)
        pan(element, :up, from: {x: 50, y: 90}, to: {x: 50, y: 10})
      end

      def drag_and_drop_to(query, query_to)
        drag_and_drop(query, query_to, 10, 1.5, 0.5)
      end

      def scroll(element, direction)
        dir = (direction.to_sym == :up) ? :down : :up
        pan(element, dir)
      end

      def fast_scroll(element, direction)
        dir = (direction.to_sym == :up) ? :down : :up
        flick(element, dir)
      end

      def scroll_list_down(element)
        pan(element, :down, from: {x: 50, y: 70}, to: {x: 50, y: 30})
      end

      def long_touch(query, options = {})
        long_press query, options
      end

      def send_app_to_background(seconds)
        system("#{adb_command} shell input keyevent KEYCODE_HOME")
        sleep 10 + seconds.to_f
        system("#{adb_command} shell input keyevent KEYCODE_APP_SWITCH")
        sleep 5
        system("#{adb_command} shell input keyevent KEYCODE_DPAD_UP")
        system("#{adb_command} shell input keyevent KEYCODE_ENTER")
      end

    end
  end
end
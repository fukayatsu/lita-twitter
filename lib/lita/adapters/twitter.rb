require 'lita'
require 'lita/adapters/twitter/connector'

module Lita
  module Adapters
    class Twitter < Adapter
      config :api_key, required: true
      config :api_secret, required: true
      config :access_token, required: true
      config :access_token_secret, required: true
      config :debug, default: false

      def initialize(robot)
        super
        @connector = Connector.new(robot,
          api_key:             config.api_key,
          api_secret:          config.api_secret,
          access_token:        config.access_token,
          access_token_secret: config.access_token_secret,
        )
      end
      attr_reader :connector

      def join(user)
        connector.join(user)
      end

      def part(user)
        connector.part(user)
      end

      def set_topic(target, topic)
        connector.update_name(topic)
      end

      def send_messages(target, strings)
        connector.message(target, strings)
      end

      def run
        robot.trigger(:connected)
        connector.connect
      rescue Interrupt
        shut_down
      end

      def shut_down
        robot.trigger(:disconnected)
      end

      def mention_format(name)
        "@#{name}"
      end

      Lita.register_adapter(:twitter, Twitter)
    end
  end
end

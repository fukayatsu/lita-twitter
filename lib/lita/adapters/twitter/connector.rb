require "twitter"

module Lita
  module Adapters
    class Twitter < Adapter
      class Connector
        def initialize(robot, api_key: nil, api_secret: nil, access_token: nil, access_token_secret: nil)
          @robot = robot
          @streaming_client = ::Twitter::Streaming::Client.new do |config|
            config.consumer_key        = api_key
            config.consumer_secret     = api_secret
            config.access_token        = access_token
            config.access_token_secret = access_token_secret
          end

          @rest_client = ::Twitter::REST::Client.new do |config|
            config.consumer_key        = api_key
            config.consumer_secret     = api_secret
            config.access_token        = access_token
            config.access_token_secret = access_token_secret
          end
        end
        attr_reader :robot, :streaming_client, :rest_client

        def connect
          streaming_client.user do |object|
            case object
            when ::Twitter::Tweet
              tweet = object
              if tweet.user.screen_name != robot.name
                text = tweet.text.dup
                mention = false
                if text.match(/\A@#{robot.name} /)
                  text.gsub!(/\A@#{robot.name} /, '')
                  mention = true
                end
                user    = User.new(tweet.user.id, name: tweet.user.screen_name, mention: mention)
                source  = Source.new(user: user, room: tweet.id)
                message = Message.new(robot, text, source)
                message.command! if mention
                robot.receive(message)
              end
            when ::Twitter::DirectMessage
              dm = object
              dm.text
              if dm.sender.screen_name != robot.name
                user    = User.new(dm.sender.id, name: dm.sender.screen_name)
                source  = Source.new(user: user)
                message = Message.new(robot, dm.text.dup, source)
                message.command!
                robot.receive(message)
              end
            end
          end
        end

        def message(target, strings)
          text = strings.join("\n")[0...140]
          if target.private_message
            rest_client.create_direct_message(target.user.name, text)
          elsif target.user
            text = "@#{target.user.name} #{text}"[0...140]
            rest_client.update(text, in_reply_to_status_id: target.room)
          else
            rest_client.update(text)
          end
        end

        def rooms
        end

        def shut_down
        end

      private
      end
    end
    Lita.register_adapter(:twitter, Twitter)
  end
end
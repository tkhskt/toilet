class LineController < ApplicationController
    require 'line/bot'
    protect_from_forgery :except => [:callback]
  
    def callback
      body = request.body.read
  
      signature = request.env['HTTP_X_LINE_SIGNATURE']
      unless client.validate_signature(body, signature)
        error 400 do 'Bad Request' end
      end
  
      events = client.parse_events_from(body)
      events.each { |event|
        case event
        when Line::Bot::Event::Message
          case event.type
          when Line::Bot::Event::MessageType::Location
            toiletList = Toilet.getToiletList(event.message["latitude"],event.message["longitude"])
            logger.debug(event)
            if toiletList.length > 0 then
                toilet = Toilet.getToiletInfoByToiletId(toiletList[0]["place_id"])
                message = {
                    type: 'location',
                    title: '周辺のトイレ',
                    address: toilet["formatted_address"],
                    latitude: toiletList[0]["geometry"]["location"]["lat"],
                    longitude: toiletList[0]["geometry"]["location"]["lng"],
                  }
            else
                message = {
                    type: 'text',
                    text: '周辺のトイレが見つかりませんでした'
                  }
            end
            
            response = client.reply_message(event['replyToken'], message)
            p response
          end
        end
      }
      head :ok
    end
  
    private
    def client
      @client ||= Line::Bot::Client.new { |config|
        config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
        config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
      }
    end
end

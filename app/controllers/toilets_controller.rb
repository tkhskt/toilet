class ToiletsController < ApplicationController
    def description
        placeId = params[:id]
        key = ENV["GOOGLE_KEY"]
        # hash形式でパラメタ文字列を指定し、URL形式にエンコード
        params = URI.encode_www_form({placeid: placeId,key: key})
        # URIを解析し、hostやportをバラバラに取得できるようにする
        uri = URI.parse("https://maps.googleapis.com/maps/api/place/details/json?#{params}")
        # リクエストパラメタを、インスタンス変数に格納
        
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE 
        response = http.start do |h|
          h.open_timeout = 5
          h.read_timeout = 10
          h.get(uri.request_uri)
        end
        @reviews = {}
        @review = {}
    
        begin
          case response
          when Net::HTTPSuccess # 結果の受け取り
            resp = JSON.load(response.body)
            @result = resp["result"]
            logger.debug(@result)
            
            r = Toilet.findToiletsByGoogleId(placeId)
            if r != nil then 
                result["description"] = r.description
                result["valuation"] = r.valuation
            else
                result[index]["description"] = ""
                result[index]["valuation"] = 0.0
            end
        
            render 'toilets/toilets'
          when Net::HTTPRedirection
            message = "Redirection: code=#{response.code} message=#{response.message}"
            render 'toilets/toilets'
          else
            message = "HTTP ERROR: code=#{response.code} message=#{response.message}"
            render 'toilets/toilets'
          end
        rescue => e
          logger.debug(e.message)
          render 'toilets/toilets'
        end
    end
end

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
       
        @toiletId = placeId
        toilet = Toilet.find_by(google_id: placeId)
        @reviews = []
        unless toilet.nil? then
            res = Review.select(Arel.star).where(Review.arel_table[:toilet_id].eq(toilet.id)).joins(
                Review.arel_table.join(User.arel_table).on(
                  User.arel_table[:id].eq(Review.arel_table[:user_id])
                ).join_sources
              )
            @reviews = res.as_json
        end    
    

        begin
          case response
          when Net::HTTPSuccess # 結果の受け取り
            resp = JSON.load(response.body)
            @result = resp["result"]
            
            r = Toilet.new.findToiletsByGoogleId(placeId)
            unless r.nil? then 
                value = Review.new.calcValuationByToiletId(r.id)
                @result["name"] = r.name
                @result["icon"] = r.image_path
                @result["description"] = r.description
                @result["valuation"] = value
                r.valuation = value
                @valueImg = Review.new.getStarPathByValuation(value)
                r.save
            else
                @result["description"] = ""
                @result["valuation"] = 0.0
                @result["icon"] = "/default.jpg"
                @valueImg = "1_star.png"
            end
            
            @list = Toilet.new.getToiletList(@result["geometry"]["location"]["lat"],@result["geometry"]["location"]["lng"])
            

            render 'toilets/toilets'
          when Net::HTTPRedirection
            message = "Redirection: code=#{response.code} message=#{response.message}"
            render 'toilets/toilets'
          else
            message = "HTTP ERROR: code=#{response.code} message=#{response.message}"
            render 'toilets/toilets'
          end
        rescue => e
          logger.debug(e)
          render 'toilets/toilets'
        end
    end



    def edit
        tId = params[:toiletId]
        toilet = Toilet.new.findToiletsByGoogleId(tId)
        if toilet.nil? then 
            toiletByAPI = Toilet.getToiletInfoByToiletId(tId)
            t = Toilet.create(
                name: toiletByAPI["name"],
                google_id: tId,
                lat: toiletByAPI["geometry"]["location"]["lat"],
                lng: toiletByAPI["geometry"]["location"]["lng"],
                geolocation: toiletByAPI["formatted_address"],
                description: "",
            )
            t.image_path = Rails.root.join("public/default.jpg").open
            t.save()
            toilet = Toilet.new.findToiletsByGoogleId(tId)
        end
        unless params[:image_path].blank? then  
            toilet.image_path = params[:image_path]
        end
        if params[:toiletName] != "" then
            toilet.name = params[:toiletName]
        end
        if params[:toiletDescription] != "" then
            toilet.description = params[:toiletDescription]
        end
        toilet.save
        redirect_to "/toilet/#{tId}"
    end
end

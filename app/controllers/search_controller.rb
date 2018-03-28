require 'xmlsimple'

class SearchController < ApplicationController
    def search
        keyword = params[:keyword]
        key = ENV["GOOGLE_KEY"]
        geoPoint = Toilet.getPlaceByKeyWord(keyword)
        lat = geoPoint["coordinate"][0]["lat"][0]
        lng = geoPoint["coordinate"][0]["lng"][0]
        location = lat + "," + lng
        

        # hash形式でパラメタ文字列を指定し、URL形式にエンコード
        params = URI.encode_www_form({key: key, location: location, radius: 5000, keyword: "トイレ"})
        # URIを解析し、hostやportをバラバラに取得できるようにする
        uri = URI.parse("https://maps.googleapis.com/maps/api/place/nearbysearch/json?#{params}")
        # リクエストパラメタを、インスタンス変数に格納
        
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE 
        response = http.start do |h|
          h.open_timeout = 5
          h.read_timeout = 10
          h.get(uri.request_uri)
        end
    
        begin
          case response
          when Net::HTTPSuccess # 結果の受け取り
            resp = JSON.load(response.body)
            @result = []
            @query = "#{keyword}の検索結果"
        

            resp["results"].each_with_index do |value, index| 
                p = value
                r = Toilet.find_by(google_id: value["place_id"])
                
                if r != nil then 
                    p["name"] = r.name
                    p["icon"] = r.image_path
                    p["description"] = r.description
                    p["valuation"] = r.valuation
                else
                    p["description"] = ""
                    p["valuation"] = 0.0
                end
                @result.push(p)
            end
           

            render 'search/search'
          when Net::HTTPRedirection
            message = "Redirection: code=#{response.code} message=#{response.message}"
          else
            message = "HTTP ERROR: code=#{response.code} message=#{response.message}"
          end
        rescue => e
          message = e.message
        end
    end
end

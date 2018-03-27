class SearchController < ApplicationController
    def search
        kw = params[:keyword]
        key = ENV["GOOGLE_KEY"]
        location = "35.469716,139.629184"
        # hash形式でパラメタ文字列を指定し、URL形式にエンコード
        params = URI.encode_www_form({key: key, location: location, radius: 5000, keyword: kw})
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
            @result = resp["results"]
            @query = "#{kw}の検索結果"
            resp["results"].each_with_index{|value, index| 
                r = Toilet.findToiletsByGoogleId(value["place_id"])
                if r != nil then 
                    result[index]["description"] = r.description
                    result[index]["valuation"] = r.valuation
                else
                    result[index]["description"] = ""
                    result[index]["valuation"] = 0.0
                end
            }
        
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

class Toilet < ApplicationRecord
    has_many :reviews
    mount_uploader :image_path, ImageUploader

    def findToiletsByGoogleId(toiletId)
        Toilet.find_by(google_id: toiletId)
    end

    def findToiletById(id)
        Toilet.find_by(id: id)
    end

    def self.getToiletInfoByToiletId(placeId)
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
       
        begin
          case response
          when Net::HTTPSuccess # 結果の受け取り
            resp = JSON.load(response.body)
            result = resp["result"]
        
          when Net::HTTPRedirection
            nil
          else
            nil
          end
        rescue => e
          nil
        
        end
    end
    def self.getPlaceByKeyWord(keyword)
        # hash形式でパラメタ文字列を指定し、URL形式にエンコード
        params = URI.encode_www_form({q: keyword})
        # URIを解析し、hostやportをバラバラに取得できるようにする
        uri = URI.parse("https://www.geocoding.jp/api/?#{params}")
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
            resp = XmlSimple.xml_in(response.body.to_str)
          when Net::HTTPRedirection
            nil
          else
            
            nil
          end
        rescue => e
          nil
        end
    end

    def getToiletList(lat,lng)
        
        key = ENV["GOOGLE_KEY"]
        location = "#{lat},#{lng}"
        
        # hash形式でパラメタ文字列を指定し、URL形式にエンコード
        params = URI.encode_www_form({key: key, location: location, radius: 2000, keyword: "トイレ"})
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
            result = []

            resp["results"].each_with_index do |value, index| 
                p = value
                r = Toilet.find_by(google_id: value["place_id"])
                if r != nil then 
                    p["name"] = r.name
                    p["description"] = r.description
                    p["valuation"] = r.valuation
                    p["icon"] = r.image_path #"https://maps.gstatic.com/mapfiles/place_api/icons/generic_business-71.png"
                else
                    p["description"] = ""
                    p["valuation"] = 0.0
                    p["icon"] = "/default.jpg"
                end
                result.push(p)
            end
           
            return result
          when Net::HTTPRedirection
            nil
          else
            nil
          end
        rescue => e
          logger.debug(e)
        end
    end

    def getPopularToilets
        Toilet.select(Arel.star).order(:valuation).reverse_order.limit(20)
    end

end

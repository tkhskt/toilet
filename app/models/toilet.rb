class Toilet < ApplicationRecord
    has_many :reviews
    mount_uploader :image_path, ImageUploader

    def findToiletsByGoogleId(toiletId)
        return Toilet.find_by(google_id: toiletId)
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

end

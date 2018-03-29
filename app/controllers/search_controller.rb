require 'xmlsimple'

class SearchController < ApplicationController
    def search
        keyword = params[:keyword]
        key = ENV["GOOGLE_KEY"]
        geoPoint = Toilet.getPlaceByKeyWord(keyword)
        if geoPoint["error"].nil? then
            lat = geoPoint["coordinate"][0]["lat"][0]
            lng = geoPoint["coordinate"][0]["lng"][0]
            location = lat + "," + lng
        else 
            @query = "#{keyword}の検索結果"
            @result = []
            render 'search/search'
            return
        end
        @topUser = User.getPopularUsers()
        @result = Toilet.getToiletList(lat,lng)
        @query = "#{keyword}の検索結果"
        render 'search/search'
    end
end

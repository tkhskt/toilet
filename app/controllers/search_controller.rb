require 'xmlsimple'

class SearchController < ApplicationController
    def search
        keyword = params[:keyword]
        key = ENV["GOOGLE_KEY"]
        geoPoint = Toilet.getPlaceByKeyWord(keyword)
        if geoPoint["error"].nil? && keyword != "" then
            lat = geoPoint["coordinate"][0]["lat"][0]
            lng = geoPoint["coordinate"][0]["lng"][0]
            location = lat + "," + lng
        else 
            @query = "#{keyword}周辺のトイレ"
            @result = []
            @topUser = User.getPopularUsers()
            render 'search/search'
            return
        end
        @topUser = User.getPopularUsers()
        @result = Toilet.getToiletList(lat,lng)
        @query = "#{keyword}周辺のトイレ"
        render 'search/search'
    end
end

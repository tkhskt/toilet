class TopPageController < ApplicationController
    def index
        toilets = Toilet.new.getPopularToilets()
        @result = []
        toilets.each do |v| 
            p = JSON.parse(v.to_json)
            p["icon"] = v.image_path
            @result.push(p)
        end
        render "top_page/top" 
    end
end

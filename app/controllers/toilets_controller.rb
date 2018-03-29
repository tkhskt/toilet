class ToiletsController < ApplicationController
    def description
        placeId = params[:id]
        
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
        
        resp = JSON.load(response.body)
        @result = Toilet.getToiletInfoByToiletId(placeId)
        
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
        
        @list = Toilet.getToiletList(@result["geometry"]["location"]["lat"],@result["geometry"]["location"]["lng"])
        
        render 'toilets/toilets'
          
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

class BookmarksController < ApplicationController
    def create
        placeId = params[:toiletId]
        userId = current_user.id
        toilet = Toilet.new.findToiletsByGoogleId(placeId)
        if toilet.nil? then
            toiletByAPI = Toilet.getToiletInfoByToiletId(placeId)
           
            t = Toilet.create(
                name: toiletByAPI["name"],
                google_id: placeId,
                lat: toiletByAPI["geometry"]["location"]["lat"],
                lng: toiletByAPI["geometry"]["location"]["lng"],
                geolocation: toiletByAPI["formatted_address"],
                image_path: toiletByAPI["icon"],
                description: "",
            )
            t.image_path = Rails.root.join("public/default.jpg").open
            t.save()
            toilet = Toilet.new.findToiletsByGoogleId(placeId)
        end
        rec = UsersToilet.where(user_id: userId, toilet_id: toilet.id).first
    
        if rec.nil? then
            UsersToilet.create(
                user_id: userId,
                toilet_id: toilet.id,
            )
        end
    end

    def destroy
        toilet_id = Toilet.find_by(google_id: params[:toiletId])
        userId = current_user.id
        UsersToilet.where(toilet_id: toilet_id, user_id: userId).first.destroy
        redirect_to "/bookmarks"
    end

    def show
        userId = current_user.id
        @name = current_user.username
        jsonResult = UsersToilet.new.getBookmarkIds(userId).to_json
        ids = JSON.parse(jsonResult)
        toiletIds = []
        logger.debug(ids)
        ids.each do |v|
            toiletIds.push(v["toilet_id"])
        end
        toilets = []
        toiletIds.each do |v|
            toilets.push(Toilet.new.findToiletById(v))
        end
        @bookmarks = []
        toilets.each do |v| 
            p = JSON.parse(v.to_json)
            p["icon"] = v.image_path
            @bookmarks.push(p)
        end

        render 'bookmarks/bookmarks'
    end
end

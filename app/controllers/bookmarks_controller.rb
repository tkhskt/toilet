class BookmarksController < ApplicationController
    def create
        placeId = params[:toiletId]
        userId = current_user.id
        toilet = Toilet.new.findToiletsByGoogleId(placeId)
        if toilet.nil? then
            toiletByAPI = Toilet.new.getToiletInfoByToiletId(placeId)
            Toilet.create(
                name: toiletByAPI["name"],
                google_id: placeId,
                lat: toiletByAPI["geometry"]["location"]["lat"],
                lng: toiletByAPI["geometry"]["location"]["lng"],
                geolocation: toiletByAPI["formatted_address"],
                image_path: toiletByAPI["icon"],
                description: "",
            )
            toilet = Toilet.new.findToiletsByGoogleId(placeId)
        end
        rec = UsersToilet.where(user_id: userId, toilet_id: toilet.id).first
        logger.debug(rec)
        if rec.nil? then
            UsersToilet.create(
                user_id: userId,
                toilet_id: toilet.id,
            )
        end
    end

    def destroy

    end
end

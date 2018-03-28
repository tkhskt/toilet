class ReviewsController < ApplicationController
    def post
        valuation = params[:valuation]
        message = params[:message]
        toiletId = params[:toiletId]
        t = Toilet.find_by(google_id: toiletId)
       
        if t.nil? 
            toiletByGoogle = Toilet.getToiletInfoByToiletId(toiletId)
            logger.debug(toiletByGoogle)
            Toilet.create(
                name: toiletByGoogle["name"],
                google_id: toiletId,
                lat: toiletByGoogle["geometry"]["location"]["lat"],
                lng: toiletByGoogle["geometry"]["location"]["lng"],
                geolocation: toiletByGoogle["formatted_address"],
                image_path: toiletByGoogle["icon"],
                description: "",
                valuation: valuation,
            )
        end
        t = Toilet.find_by(google_id: toiletId)

        Review.create(
            toilet_id: t.id,
            user_id: current_user.id,
            valuation: valuation,
            message: message,
        )
    end
    def after_update_path_for(resource)
    end
end

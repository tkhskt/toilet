class ReviewsController < ApplicationController
    def post
        valuation = params[:valuation]
        message = params[:message]
        toiletId = params[:toiletId]
        t = Toilet.find_by(google_id: toiletId)
       
        if t.nil? then
            toiletByGoogle = Toilet.getToiletInfoByToiletId(toiletId)
            
            newToilet = Toilet.create(
                name: toiletByGoogle["name"],
                google_id: toiletId,
                lat: toiletByGoogle["geometry"]["location"]["lat"],
                lng: toiletByGoogle["geometry"]["location"]["lng"],
                geolocation: toiletByGoogle["formatted_address"],
                description: "",
                valuation: valuation,
            )
            newToilet.image_path = Rails.root.join("public/default.jpg").open
            newToilet.save()
        end
        t = Toilet.find_by(google_id: toiletId)

        Review.create(
            toilet_id: t.id,
            user_id: current_user.id,
            valuation: valuation,
            message: message,
        )
        redirect_to "/toilet/#{toiletId}"
    end
    def after_update_path_for(resource)
    end
end

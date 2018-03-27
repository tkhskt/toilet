class ReviewsController < ApplicationController
    def post
        title = params[:title]
        message = params[:message]
        logger.debug(title)
    end
    def after_update_path_for(resource)
    end
end

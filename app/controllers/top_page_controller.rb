class TopPageController < ApplicationController
    def index
        #logger.debug(current_user.username)
        render "top_page/top" 
    end
end

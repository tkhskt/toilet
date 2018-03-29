class UsersToilet < ApplicationRecord
    def getBookmarkIds(userId) 
        UsersToilet.where(user_id: userId)
    end
end

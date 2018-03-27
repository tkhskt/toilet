class Toilet < ApplicationRecord
    def findToiletsByGoogleId(toiletId)
        return Toilet.find_by(google_id: toiletId)
    end
end

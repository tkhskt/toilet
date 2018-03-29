class Review < ApplicationRecord
    belongs_to :user
    belongs_to :toilet

    def calcValuationByToiletId(toiletId)
        reviews = Review.where(toilet_id: toiletId)
        sum = 0.0
        res = 0.0
        if reviews.length != 0 then
            logger.debug(reviews.length)
            reviews.each do |v|
                sum += v.valuation
            end
            res = sum/reviews.length
            res = BigDecimal(res.to_s).floor(1).to_f
        end       
        return res
    end

    def getStarPathByValuation(valuation)
        if valuation < 2 then
            "1_star.png"
        elsif valuation < 3 then
            "2_star.png"
        elsif valuation < 4 then
            "3_star.png"
        elsif valuation < 5 then
            "4_star.png"
        else 
            "5_star.png"
        end
    end
end

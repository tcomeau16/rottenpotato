class Movie < ActiveRecord::Base
    
    def self.ratings

        distinct_ratings = Array.new
        Movie.select("rating").order("rating").distinct.each { |rating| distinct_ratings.push(rating.read_attribute("rating")) }
        distinct_ratings
    end
end

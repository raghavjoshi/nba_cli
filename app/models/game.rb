class Game < ActiveRecord::Base
    validate :home, :away, :score
end

class Team < ActiveRecord::Base
    has_many :players
    validate :name, :abbrev
end

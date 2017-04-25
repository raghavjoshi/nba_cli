class TeamStat < ActiveRecord::Base
    validate :name, :abbrev
end

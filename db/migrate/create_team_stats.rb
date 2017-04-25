class CreateTeamStats < ActiveRecord::Migration
    def change
        create_table :team_stats do |t|
            t.integer :team_id
            t.integer :year
            t.float :min
            t.float :points
            t.float :fgm
            t.float :fga
            t.float :fg_percentage
            t.float :three_pm
            t.float :three_pa
            t.float :three_percentage
            t.float :ftm
            t.float :fta
            t.float :ft_percentage
            t.float :oreb
            t.float :dreb
            t.float :treb
            t.float :ast
            t.float :tov
            t.float :stl
            t.float :blk
            t.float :per
            t.timestamps null: false
        end
    end
end

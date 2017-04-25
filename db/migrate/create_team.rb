class CreateTeam < ActiveRecord::Migration
    def change
        create_table :teams do |t|
            t.integer :team_id
            t.string :name
            t.string :abbrev
            t.timestamps null:false
        end
    end
end

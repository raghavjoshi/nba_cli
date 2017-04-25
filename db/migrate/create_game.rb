class CreateGame < ActiveRecord::Migration
    def change
        create_table :games do |t|
            t.integer :game_id
            t.string :home
            t.string :away
            t.string :score
            t.timestamps null: false
        end
    end
end

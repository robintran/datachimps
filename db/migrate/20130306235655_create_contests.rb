class CreateContests < ActiveRecord::Migration
  def change
    create_table :contests do |t|
      t.integer :user_id
      t.string :name
      t.text :description
      t.datetime :deadline
      t.integer :winner_id
      t.integer :bounty

      t.timestamps
    end
  end
end

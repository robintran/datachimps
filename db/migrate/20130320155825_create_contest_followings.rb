class CreateContestFollowings < ActiveRecord::Migration
  def change
    create_table :contest_followings do |t|
      t.references :contest
      t.references :user

      t.timestamps
    end
    add_index :contest_followings, :contest_id
    add_index :contest_followings, :user_id
  end
end

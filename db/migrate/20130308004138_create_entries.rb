class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.integer :contest_id
      t.integer :user_id
      t.text :description
      t.string :data_set_url
      t.integer :rating

      t.timestamps
    end
  end
end

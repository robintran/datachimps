class AddRemovedToEntry < ActiveRecord::Migration
  def change
    add_column :entries, :removed, :boolean, default: false
  end
end

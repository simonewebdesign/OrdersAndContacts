class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people, as_relation_superclass: true do |t|
      t.integer :age

      t.timestamps
    end
  end
end
class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts, as_relation_superclass: true do |t|
      t.string :name
      t.string :email

      t.timestamps
    end
  end
end

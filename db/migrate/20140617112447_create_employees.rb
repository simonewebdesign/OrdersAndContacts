class CreateEmployees < ActiveRecord::Migration
  def change
    create_table :employees do |t|
      t.float :salary

      t.timestamps
    end
  end
end

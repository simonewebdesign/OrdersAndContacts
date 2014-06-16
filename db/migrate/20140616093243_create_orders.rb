class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.references :contact, index: true

      t.timestamps
    end
  end
end

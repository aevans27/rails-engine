class CreateItems < ActiveRecord::Migration[7.0]
  def change
    create_table :items do |t|
      t.string :name
      t.string :description
      t.string :unit_price
      t.string :merchant_id

      t.timestamps
    end
  end
end

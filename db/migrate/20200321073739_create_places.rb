class CreatePlaces < ActiveRecord::Migration[5.2]
  def change
    create_table :places do |t|
      t.string :name
      t.text :address
      t.float :latitude
      t.float :longitude
      t.text :description
      t.string :subtitle
      t.string :price
      t.string :website
      t.string :phone
      t.string :price_2

      t.timestamps
    end
  end
end

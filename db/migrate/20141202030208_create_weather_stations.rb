class CreateWeatherStations < ActiveRecord::Migration
  def change
    create_table :weather_stations, :id => false do |t|
      t.integer :id,       null: false
      t.string  :name,     null: false
      t.string  :province, null: false
      t.point   :latlon,   null: false
    end

    change_table :weather_stations do |t|
      t.index :id,         unique: true
      t.index :latlon,     spatial: true
    end
  end
end

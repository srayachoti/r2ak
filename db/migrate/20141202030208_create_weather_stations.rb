class CreateWeatherStations < ActiveRecord::Migration
  def change
    create_table :weather_stations do |t|
      t.string  :name
      t.string  :province
      t.point   :latlon

      t.index   :latlon, spatial: true
    end
  end
end

class WeatherStation < ActiveRecord::Base
  set_rgeo_factory_for_column :latlon, RGeo::Geographic.spherical_factory

  has_many :weather_observations
end
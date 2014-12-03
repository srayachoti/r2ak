class WeatherStation < ActiveRecord::Base
  self.rgeo_factory_generator = RGeo::Geos.method(:factory)

  attr_accessible :name, :province, :latlon

  has_many :weather_observations
end

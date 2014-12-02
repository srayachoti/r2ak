require 'date'
require 'rest-client'

BulkURL    = %q(http://climate.weather.gc.ca/climateData/bulkdata_e.html)
StationIDs = %w(27226 96 6831 6813 152 27382 145 153 29733 137)
YearRange  = 1994..2014
MonthRange = 6..6

for station_id in StationIDs
  puts "fetching data for station #{station_id} ..."
 
  for year in YearRange
    for month in MonthRange
      date = Date.new(year, month)

      puts "fetching data for #{date.strftime('%Y-%m-%d')} ..."

      response = RestClient.get BulkURL, :params => {
                                           :format    => :csv,
                                           :stationID => station_id,
                                           :Year      => date.year,
                                           :Month     => date.month,
                                           :timeframe => 1
                                         }

      if response.code == 200
        filename = "data/#{station_id}-#{date.strftime('%Y%m%d')}.csv"
        File.open(filename, 'w') { |f| f.write response.body.encode("UTF-8", :invalid => :replace, :undef => :replace, :replace => '?') }
      else
        STDERR.puts "failed to fetch data for station #{station_id} for #{date.strftime('%Y-%m-%d')}"
      end
    end
  end

  puts
end

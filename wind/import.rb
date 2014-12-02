require 'csv'
require 'date'

speeds = []

for filename in Dir.glob('data/*.csv')
  unless filename.match(/(\d+)-/) 
    STDERR.puts "failed to determine station ID from #{filename}"
    next
  end
  station_id = $1
 
  csv = CSV.read(filename)

  puts "data for station #{station_id}:"

  station_rows = csv[0..3]
  station_rows.each do |row|
    puts "#{row[0]}: #{row[1]}"
  end

  weather_rows = csv[17..-1]
  weather_rows.each do |row|
    time  = DateTime.strptime(row[0], '%Y-%m-%d %H:%M')
    dir   = (row[12] && !row[12].empty?) ? row[12].to_i*10 : nil
    speed = (row[14] && !row[14].empty?) ? row[14].to_i : nil

    speeds.push(speed) if !speed.nil?

    #puts "#{time.strftime('%Y-%m-%d %H:%M')}: #{speed} km/h, #{dir} deg"
  end 

  puts
end 

speeds.sort!
puts "min speed: #{speeds.first*0.539957} kts"
puts "max speed: #{speeds.last*0.539957} kts"
puts "avg speed: #{speeds.inject { |sum, s| sum + s }.to_f/speeds.size*0.539957} kts"
puts "median speed: #{speeds[speeds.length/2]*0.539957} kts"

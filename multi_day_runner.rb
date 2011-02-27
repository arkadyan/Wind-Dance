dates = '01.08.2009,02.08.2009,03.08.2009,04.08.2009,05.08.2009,06.08.2009,07.08.2009,08.08.2009,09.08.2009,10.08.2009,11.08.2009,12.08.2009,13.08.2009,14.08.2009,15.08.2009,16.08.2009,17.08.2009,18.08.2009,19.08.2009,20.08.2009,21.08.2009,22.08.2009,23.08.2009,24.08.2009,25.08.2009,26.08.2009,27.08.2009,28.08.2009,29.08.2009,30.08.2009,31.08.2009'
puts "dates = #{dates}"

# Define offsets for days whose data would extend
# beyond the bounds of the print
case dates
when '04.08.2009'
	starting_offset_x = 1500
	starting_offset_y = 500
when '05.08.2009'
	starting_offset_x = 3300
	starting_offset_y = 1800
when '06.08.2009'
	starting_offset_x = 2800
	starting_offset_y = 2800
when '07.08.2009'
	starting_offset_x = 3800
	starting_offset_y = 3500
when '09.08.2009'
	starting_offset_x = 1000
	starting_offset_y = 200
when '10.08.2009'
	starting_offset_x = 3500
	starting_offset_y = 2500
when '11.08.2009'
	starting_offset_x = 3000
	starting_offset_y = 3000
when '18.08.2009'
	starting_offset_x = 2000
	starting_offset_y = 1500
when '20.08.2009', '21.08.2009'
	starting_offset_x = 1500
	starting_offset_y = 800
when '26.08.2009'
	starting_offset_x = 3500
	starting_offset_y = 2500
else
	starting_offset_x = 0
	starting_offset_y = 0
end

size = 4000
puts `rp5 run dance_diagram.rp5 DanceDiagram #{size} #{size} #{dates} data/spws-data-flux-809-data_only.csv 1-31.08.2009 #{starting_offset_x} #{starting_offset_y} 0 23`

(01..01).each do |day|
	date = "#{"%02d" % day}.02.2010"
	puts "date = #{date}"
	
	starting_offset_x = 3800
	starting_offset_y = 0
	
	size = 4000
	puts `rp5 run dance_diagram.rb DanceDiagram #{size} #{size} #{date} data/concord_feb_2010_wind.csv #{date} #{starting_offset_x} #{starting_offset_y} 0 23`
end

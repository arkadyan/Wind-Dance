(01..01).each do |day|
	date = "#{"%02d" % day}.10.1844"
	puts "date = #{date}"
	
	starting_offset_x = 0
	starting_offset_y = 0
	
	size = 4000
	puts `rp5 run dance_diagram.rb DanceDiagram #{size} #{size} #{date} data/thoreau_data.csv #{date} #{starting_offset_x} #{starting_offset_y} 0 23`
end

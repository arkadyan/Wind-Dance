(21..21).each do |day|
	date = "#{"%02d" % day}.09.2010"
	puts "date = #{date}"
	
	starting_offset_x = 3800
	starting_offset_y = 0
	
	size = 4000
	puts `rp5 run dance_diagram.rb DanceDiagram #{size} #{size} #{date} data/concordautumneqwind.csv #{date} #{starting_offset_x} #{starting_offset_y} 0 22`
end

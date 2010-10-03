(21..21).each do |day|
	date = "#{"%02d" % day}.09.2010"
	
	# Define offsets for days whose data would extend
	# beyond the bounds of the print
	# case date
	# when '04.08.2009'
	# 	starting_offset_x = 1500
	# 	starting_offset_y = 500
	# else
		starting_offset_x = 0
		starting_offset_y = 0
	# end
	
	size = 4000
	`rp5 run dance_diagram.rb DanceDiagram #{size} #{size} #{date} data/concordautumneqwind.csv #{date} #{starting_offset_x} #{starting_offset_y}`
end

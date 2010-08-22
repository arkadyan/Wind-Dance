# (1..31).each do |day|
(1..7).each do |day|
	date = "#{"%02d" % day}.08.2009"
	
	# Define offsets for days whose data would extend
	# beyond the bounds of the print
	case date
	when '04.08.2009'
		starting_offset_x = 2000
		starting_offset_y = 1000
	when '07.08.2009'
		starting_offset_x = 5500
		starting_offset_y = 5000
	when '09.08.2009'
		starting_offset_x = 1500
		starting_offset_y = 700
	when '10.08.2009'
		starting_offset_x = 4500
		starting_offset_y = 3500
	when '11.08.2009'
		starting_offset_x = 4500
		starting_offset_y = 4500
	else
		starting_offset_x = 0
		starting_offset_y = 0
	end
	
	# size = 700
	# size = 1600
	# size =  2400
	# size =  3600
	size =  6000
	# size =  7200
	`rp5 run dance_diagram.rb DanceDiagram #{size} #{size} #{date} data/spws-data-flux-809-data_only.csv #{date} #{starting_offset_x} #{starting_offset_y}`
end

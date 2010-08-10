(1..31).each do |day|
	date = "#{"%02d" % day}.08.2009"
	
	# Define offsets for days whose data would extend
	# beyond the bounds of the print
	case date
	when '07.08.2009'
		starting_offset_x = 6500
		starting_offset_y = 6500
	else
		starting_offset_x = 0
		starting_offset_y = 0
	end
	
	# `rp5 run dance_diagram.rb DanceDiagram 700 700 #{date} data/spws-data-flux-809-data_only.csv #{date}`
	# `rp5 run dance_diagram.rb DanceDiagram 1600 1600 #{date} data/spws-data-flux-809-data_only.csv #{date}`
	# `rp5 run dance_diagram.rb DanceDiagram 2400 2400 #{date} data/spws-data-flux-809-data_only.csv #{date}`
	# `rp5 run dance_diagram.rb DanceDiagram 3600 3600 #{date} data/spws-data-flux-809-data_only.csv #{date}`
	`rp5 run dance_diagram.rb DanceDiagram 7200 7200 #{date} data/spws-data-flux-809-data_only.csv #{date} #{starting_offset_x} #{starting_offset_y}`
end

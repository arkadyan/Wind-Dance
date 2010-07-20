(1..31).each do |day|
	date = "#{"%02d" % day}.08.2009"
	`rp5 run dance_diagram.rb DanceDiagram 700 700 #{date} data/spws-data-flux-809-data_only.csv #{date}`
end

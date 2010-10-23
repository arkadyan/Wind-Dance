['01.10.1844','25.03.1846','08.04.1847','28.03.1851','23.03.1853'].each do |date|
	puts "date = #{date}"
	
	starting_offset_x = 2200
	starting_offset_y = 3200
	
	size = 4000
	puts `rp5 run dance_diagram.rb DanceDiagram #{size} #{size} #{date} data/thoreau_1840s_1850s.csv #{date} #{starting_offset_x} #{starting_offset_y} 0 23`
end

['01.10.1844','25.03.1846','08.04.1847','28.03.1851','23.03.1853'].each do |date|
	puts "date = #{date}"
	
	case date
	when '01.10.1844'
		starting_offset_x = 2200
		starting_offset_y = 3200
	when '25.03.1846'
		starting_offset_x = 3800
		starting_offset_y = 1500
	when '08.04.1847'
		starting_offset_x = 2300
		starting_offset_y = 3000
	when '28.03.1851'
		starting_offset_x = 2500
		starting_offset_y = 3800
	when '23.03.1853'
		starting_offset_x = 3500
		starting_offset_y = 500
	else
		starting_offset_x = 0
		starting_offset_y = 0
	end
	
	size = 4000
	puts `rp5 run dance_diagram.rb DanceDiagram #{size} #{size} #{date} data/thoreau_1840s_1850s.csv #{date} #{starting_offset_x} #{starting_offset_y} 0 23`
end

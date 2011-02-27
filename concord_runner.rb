['21.02.2010','12.04.2001','23.02.2002','05.04.2005','13.03.2006'].each do |date|
	puts "date = #{date}"
	
	case date
	when '21.02.2010'
		starting_offset_x = 3930
		starting_offset_y = 0
	when '12.04.2001'
		starting_offset_x = 500
		starting_offset_y = 1800
	when '23.02.2002'
		starting_offset_x = 3100
		starting_offset_y = 3200
	when '05.04.2005'
		starting_offset_x = 3750
		starting_offset_y = 2650
	else
		starting_offset_x = 0
		starting_offset_y = 0
	end
	
	size = 4000
	puts `rp5 run dance_diagram.rp5 DanceDiagram #{size} #{size} #{date} data/concord_2000s.csv #{date} #{starting_offset_x} #{starting_offset_y} 0 23`
end

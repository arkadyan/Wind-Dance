dates = '2010-01-11,2010-01-12,2010-01-13,2010-01-14,2010-01-15,2010-01-16,2010-01-17,2010-01-18,2010-01-19,2010-01-20'
puts "dates = #{dates}"

starting_offset_x = 17000
starting_offset_y = 17000

size = 20000
puts `rp5 run dance_diagram.rp5 DanceDiagram #{size} #{size} #{dates} data/acton2010data/acton_year_1-10.csv acton_year_1-10 #{starting_offset_x} #{starting_offset_y} 0 23`

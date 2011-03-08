dates = '2010-02-05,2010-02-06,2010-02-07,2010-02-08,2010-02-09'
puts "dates = #{dates}"

starting_offset_x = 10000
starting_offset_y = 8000

size = 16000
puts `rp5 run dance_diagram.rp5 DanceDiagram #{size} #{size} #{dates} data/acton2010data/acton_year_36-40.csv acton_year_36-40 #{starting_offset_x} #{starting_offset_y} 0 23`

#!/usr/bin/env ruby

# file_names = %x[ls -1 *.csv].split(/\n/).sort_by { |f| f.split('.').first.to_i }
file_names = %x[ls -1 individual_days | grep '[0-9]' | sort -n].split(/\n/)

combined_days = ''
dates = []
# file_names.each do |file_name|
# 	IO.foreach(file_name) { |line| combined_days << line }
# end
(10..19).each do |i|
	IO.foreach('individual_days/'+file_names[i]) do |line| 
		combined_days << line
		dates << line.split(' ').first
	end
	combined_days << "\n"
end

# File.open('combined_year.csv', 'w') {|f| f.write(combined_days) }
File.open('acton_year_11-20.csv', 'w') {|f| f.write(combined_days) }
puts dates.uniq.join(',')

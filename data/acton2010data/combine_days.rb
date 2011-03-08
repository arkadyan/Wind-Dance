#!/usr/bin/env ruby

file_names = %x[ls -1 individual_days | grep '[0-9]' | sort -n].split(/\n/)

combined_days = ''
dates = []
(35..39).each do |i|
	IO.foreach('individual_days/'+file_names[i]) do |line| 
		combined_days << line
		dates << line.split(' ').first
	end
	combined_days << "\n"
end

# Remove the final newline at the end of the file
combined_days.chop!

# Change ' ' after first column to ','
combined_days.gsub!(' ', ',')

File.open('acton_year_36-40.csv', 'w') {|f| f.write(combined_days) }

puts dates.uniq.join(',')

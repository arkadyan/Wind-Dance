#!/usr/bin/env ruby

file_names = %x[ls -1 *.csv].split(/\n/).sort_by { |f| f.split('.').first.to_i }

combined_days = ''
file_names.each do |file_name|
	IO.foreach(file_name) { |line| combined_days << line }
end

File.open('combined_year.csv', 'w') {|f| f.write(combined_days) }

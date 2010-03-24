require 'ruby-processing'

class WindBarb
	include Processing::Proxy
	
	attr_accessor :speed, :direction

	def initialize(speed, direction)
		@center_x = width / 2
		@center_y = height / 2
		@dot_width = 3
		@circle_width = 20
		
		@speed = speed
		@direction = direction
	end
  
	def render
		render_calm
	end
	
	def render_calm
		# Draw center dot
		fill 0
		ellipse @center_x, @center_y, @dot_width, @dot_width
		
		# Draw outer circle
		no_fill
		ellipse @center_x, @center_y, @circle_width, @circle_width
	end
end


class DanceDiagram < Processing::App
	def setup
		no_loop
		
		@center = width / 2
		
		@barbs = load_data
	end
  
	def draw
		background 255
		stroke 0
		# render_compass_points
		# @barb.render
	end
	
	
	def load_data
		barbs = load_strings("spws-data-flux-809-selected.csv").map do |line|
			# values = line.split(',').map { |num| num.to_f }
			values = line.split(',').map
			WindBarb.new(values[0], values[1])
		end
		
		barbs.each do |barb|
			puts barb.speed
			puts barb.direction
		end
	end
	
	
	def render_compass_points
		@cardinal_length = 10
		@cardinal_weight = 4
		@intermediate_length = 7
		@intermediate_weight = 2
		@minor_length = 4
		@minor_weight = 1
		
		# Cardinal directions
		stroke_weight @cardinal_weight
		render_opposite_compass_points @cardinal_length, PI/2
		
		# Intermediate directions
		stroke_weight @intermediate_weight
		render_opposite_compass_points @intermediate_length, PI/4
		
		# Minor directions
		stroke_weight @minor_weight
		render_opposite_compass_points @minor_length, PI/8
		render_opposite_compass_points @minor_length, PI/8 + PI/4
		
		stroke_weight 1
	end
	def render_opposite_compass_points(length, angle)
		push_matrix
		translate @center, @center
		rotate angle
		line -@center, 0, -@center+length, 0
		line @center-length, 0, @center, 0
		pop_matrix
		
		push_matrix
		translate @center, @center
		rotate PI/2+angle
		line -@center, 0, -@center+length, 0
		line @center-length, 0, @center, 0
		pop_matrix
	end
end

DanceDiagram.new :title => "DanceDiagram", :width => 700, :height => 700

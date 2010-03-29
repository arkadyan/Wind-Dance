require 'ruby-processing'

class WindBarb
	include Processing::Proxy
	
	attr_accessor :speed, :direction, :x, :y

	def initialize(speed, direction)
		@x = width / 2
		@y = height / 2
		@dot_width = 3
		@circle_width = 20
		
		@speed = speed
		@direction = direction
	end
	
	def direction_in_radians
		case @direction
		when 'E'
			0
		when 'ENE'
			-PI/8
		when 'NE'
			-PI/4
		when 'NNE'
			-PI*3/8
		when 'N'
			-PI/2
		when 'NNW'
			-PI*5/8
		when 'NW'
			-PI*3/4
		when 'WNW'
			-PI*7/8
		when 'W'
			-PI
		when 'WSW'
			-PI*9/8
		when 'SW'
			-PI*5/4
		when 'SSW'
			-PI*11/8
		when 'S'
			-PI*3/2
		when 'SSE'
			-PI*13/8
		when 'SE'
			-PI*7/4
		when 'ESE'
			-PI*15/8
		else
			0
		end
	end
  
	def render
		if speed == 0
			render_calm
		else
			render_step
		end
	end
	
	def render_calm
		# Draw center dot
		fill 0
		ellipse @x, @y, @dot_width, @dot_width
		
		# Draw outer circle
		no_fill
		ellipse @x, @y, @circle_width, @circle_width
	end
	
	def render_step
		rect_mode CENTER
		rect @x, @y, @circle_width, @circle_width
	end
end


class DanceDiagram < Processing::App
	def setup
		no_loop
		
		@center = width / 2
		@current_x = @center
		@current_y = @center
		
		@barbs = load_data
	end
  
	def draw
		background 255
		stroke 0
		render_compass_points
		render_barbs
		save_image
	end
	
	
	def load_data
		input_file = "spws-data-flux-809-selected.csv"
		# input_file = "test3.csv"
		barbs = load_strings(input_file).map do |line|
			# values = line.split(',').map { |num| num.to_f }
			values = line.split(',').map
			WindBarb.new(values[0].to_f, values[1])
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
	
	def render_barbs
		@barbs.each do |barb|
			if barb.speed==0
				render_still_barb(barb)
			else
				render_step_barb(barb)
			end
		end
	end
	
	def render_still_barb(barb)
		barb.render
	end
	
	def render_step_barb(barb)
		# step_multiplier = 5
		step_multiplier = 20
		
		new_x = @current_x + barb.speed * step_multiplier * cos(barb.direction_in_radians)
		new_y = @current_y + barb.speed * step_multiplier * sin(barb.direction_in_radians)
		puts barb.direction_in_radians.to_s + ' * ' + barb.speed.to_s + ' = ' + new_x.to_s + ', ' + new_y.to_s
		
		barb.x = new_x
		barb.y = new_y
		
		# Draw arrow from previous step to the new step
		# line @current_x, @current_y, barb.x, barb.y
		# triangle barb.x, barb.y
				
		@current_x = new_x
		@current_y = new_y
		
		barb.render
	end
	
	def save_image
		save 'test_diagram'
	end
end

DanceDiagram.new :title => "DanceDiagram", :width => 700, :height => 700

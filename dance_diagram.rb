require 'ruby-processing'

class Point
	attr_accessor :x, :y
	
	def initialize(x, y)
		@x = x
		@y = y
	end
	
	def set(x, y)
		@x = x
		@y = y
	end
end

class WindBarb
	include Processing::Proxy
	
	attr_accessor :speed, :direction, :pos

	def initialize(speed, direction)
		@pos = Point.new(width/2, height/2)
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
		ellipse @pos.x, @pos.y, @dot_width, @dot_width
		
		# Draw outer circle
		no_fill
		ellipse @pos.x, @pos.y, @circle_width, @circle_width
	end
	
	def render_step
		rect_mode CENTER
		rect @pos.x, @pos.y, @circle_width, @circle_width
	end
end


class DanceDiagram < Processing::App
	def setup
		no_loop
		
		@center = width / 2
		@current_pos = Point.new(@center, @center)
		
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
		# input_file = "test2.csv"
		# input_file = "test1.csv"
		barbs = load_strings(input_file).map do |line|
			# values = line.split(',').map { |num| num.to_f }
			values = line.split(',').map
			WindBarb.new(values[0].to_f, values[1])
		end
	end
	
	
	def render_compass_points
		compass_stroke_color = 0
		@cardinal_length = 10
		@cardinal_weight = 4
		@intermediate_length = 7
		@intermediate_weight = 2
		@minor_length = 4
		@minor_weight = 1
		
		stroke compass_stroke_color
		
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
		@barb_stroke_color = 0
		# step_multiplier = 5
		step_multiplier = 60
		
		@barbs.each do |barb|
			new_x = @current_pos.x + barb.speed * step_multiplier * cos(barb.direction_in_radians)
			new_y = @current_pos.y + barb.speed * step_multiplier * sin(barb.direction_in_radians)
			puts barb.direction_in_radians.to_s + ' * ' + barb.speed.to_s + ' = ' + new_x.to_s + ', ' + new_y.to_s

			barb.pos.x = new_x
			barb.pos.y = new_y

			stroke @barb_stroke_color
			barb.render
			
			# Draw arrow from previous step to the new step
			if barb.speed > 0
				draw_arrow(@current_pos, barb.pos)
			end

			@current_pos.set(new_x, new_y)
		end
	end
	
	def draw_arrow(from, to)
		arrow_stroke_color = 150
		
		stroke arrow_stroke_color
		
		puts "from = #{from.x}, #{from.y}"
		puts "to = #{to.x}, #{to.y}"
		
		# Arrow head height and (center-to-edge) width
		arrow_height = 10
		arrow_width = 5
		
		# Draw a line from one point to the next.
		line from.x, from.y, to.x, to.y
		
		# Initial trig calculations for the arrow head
		adj = to.x - from.x
		puts "adj = #{adj}"
		opp = to.y - from.y
		puts "opp = #{opp}"
		angle = atan(adj/opp)
		puts "angle = #{angle}"
		
		# Draw the arrow head
		push_matrix
		translate from.x+adj, from.y+opp
		ration_amount = calculate_rotation(adj, opp, angle)
		if opp == 0 and adj > 0
			rotate 3*PI/2
		elsif opp == 0 and adj < 0
			rotate PI/2
		elsif adj == 0 and opp < 0
			rotate PI
		elsif adj == 0 and opp > 0
			rotate 0
		elsif angle < 0 and opp < 0
			rotate PI - angle
		elsif angle < 0 and opp > 0
			rotate 2 * PI - angle
		elsif opp < 0 and adj < 0
			rotate PI - angle
		else
			rotate 2 * PI - angle
		end
		line 0, 0, arrow_width, -arrow_height
		line 0, 0, -arrow_width, -arrow_height
		pop_matrix
	end
	
	def calculate_rotation(adj, opp, angle)
		
	end
	
	def save_image
		save 'test_diagram'
	end
end

DanceDiagram.new :title => "DanceDiagram", :width => 700, :height => 700

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
	
	attr_accessor :speed, :direction, :pos, :previous_barb

	def initialize(speed, direction, previous_barb)
		@pos = Point.new(width/2, height/2)
		@dot_width = 3
		@circle_width = 20
		
		@speed = speed
		@direction = direction
		@previous_barb = previous_barb
	end
	
	def direction_in_radians
		case @direction
		when 'E'
			0
		when 'ENE'
			-Math::PI/8
		when 'NE'
			-Math::PI/4
		when 'NNE'
			-Math::PI*3/8
		when 'N'
			-Math::PI/2
		when 'NNW'
			-Math::PI*5/8
		when 'NW'
			-Math::PI*3/4
		when 'WNW'
			-Math::PI*7/8
		when 'W'
			-Math::PI
		when 'WSW'
			-Math::PI*9/8
		when 'SW'
			-Math::PI*5/4
		when 'SSW'
			-Math::PI*11/8
		when 'S'
			-Math::PI*3/2
		when 'SSE'
			-Math::PI*13/8
		when 'SE'
			-Math::PI*7/4
		when 'ESE'
			-Math::PI*15/8
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
		# Arrow head height and (center-to-edge) width
		arrow_line_length = 30
		arrow_head_height = 8
		arrow_head_width = 4
		arrow_stroke_color = 50
		arrow_stroke_weight = 1
		
		stroke arrow_stroke_color
		stroke_weight arrow_stroke_weight
				
		# Draw center dot
		fill 0
		ellipse @pos.x, @pos.y, @dot_width, @dot_width
		
		# Draw outer circle
		no_fill
		ellipse @pos.x, @pos.y, @circle_width, @circle_width
		
		
		push_matrix
		translate @pos.x, @pos.y
		rotate 3*Math::PI/2 + direction_in_radians
		
		stroke arrow_stroke_color
		
		# Draw the arrow line
		line 0, 0, 0, arrow_line_length
		
		# Draw the arrow head
		fill arrow_stroke_color
		triangle 0, arrow_line_length, -arrow_head_width, arrow_line_length-arrow_head_height, arrow_head_width, arrow_line_length-arrow_head_height
		no_fill
		# line 0, 0, arrow_head_width, -arrow_head_height
		# line 0, 0, -arrow_head_width, -arrow_head_height
		pop_matrix
	end
	
	def render_step
		main_line_length = 30
		full_flag_length = 20
		flag_offset = 5
		flag_angle = 3*Math::PI/8
		
		from_point = Point.new(@pos.x - (main_line_length/2)*Math.cos(direction_in_radians), pos.y - (main_line_length/2)*Math.sin(direction_in_radians))
		to_point = Point.new(@pos.x + (main_line_length/2)*Math.cos(direction_in_radians), pos.y + (main_line_length/2)*Math.sin(direction_in_radians))
		
		line from_point.x, from_point.y, to_point.x, to_point.y

		# puts "speed=" + speed.to_s
		
		# Draw the 5 knots flag (for all step barbs)
		push_matrix
		translate to_point.x, to_point.y
		rotate direction_in_radians + flag_angle
		line 0, 0+flag_offset, full_flag_length/2, 0
		pop_matrix
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
		# input_file = "spws-data-flux-809-selected.csv"
		input_file = "test5.csv"
		# input_file = "test4.csv"
		# input_file = "test3.csv"
		# input_file = "test2.csv"
		# input_file = "test1.csv"
		previous_barb = nil
		barbs = load_strings(input_file).map do |line|
			# values = line.split(',').map { |num| num.to_f }
			values = line.split(',').map
			previous_barb = WindBarb.new(values[0].to_f, values[1], previous_barb)
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
		render_opposite_compass_points @cardinal_length, Math::PI/2
		
		# Intermediate directions
		stroke_weight @intermediate_weight
		render_opposite_compass_points @intermediate_length, Math::PI/4
		
		# Minor directions
		stroke_weight @minor_weight
		render_opposite_compass_points @minor_length, Math::PI/8
		render_opposite_compass_points @minor_length, Math::PI/8 + Math::PI/4
		
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
		rotate Math::PI/2+angle
		line -@center, 0, -@center+length, 0
		line @center-length, 0, @center, 0
		pop_matrix
	end
	
	def render_barbs
		barb_stroke_color = 0
		barb_stroke_weight = 2
		# step_multiplier = 6
		# step_multiplier = 15
		# step_multiplier = 40
		# step_multiplier = 60
		step_multiplier = 80
		# step_multiplier = 100
		move_from_last_step_distance = 50
		
		@barbs.each do |barb|
			new_x = @current_pos.x + barb.speed * step_multiplier * Math.cos(barb.direction_in_radians)
			new_y = @current_pos.y + barb.speed * step_multiplier * Math.sin(barb.direction_in_radians)
			# puts barb.direction_in_radians.to_s + ' * ' + barb.speed.to_s + ' = ' + new_x.to_s + ', ' + new_y.to_s

			barb.pos.x = new_x
			barb.pos.y = new_y
			
			# If the last barb was a step, move away from it in the same direction
			if barb.speed==0 and barb.previous_barb and barb.previous_barb.speed > 0
				barb.pos.x -= move_from_last_step_distance*Math.cos((3*Math::PI-barb.previous_barb.direction_in_radians).abs)
				# barb.pos.x += move_from_last_step_distance*Math.cos((3*Math::PI/2+barb.previous_barb.direction_in_radians).abs)
				barb.pos.y += move_from_last_step_distance*Math.sin((3*Math::PI-barb.previous_barb.direction_in_radians).abs)
				# barb.pos.y += move_from_last_step_distance*Math.sin((3*Math::PI/2+barb.previous_barb.direction_in_radians).abs)
			end

			stroke barb_stroke_color
			stroke_weight barb_stroke_weight
			barb.render
			
			# Draw arrow from previous step to the new step
			if barb.speed > 0
				draw_arrow(@current_pos, barb.pos)
			end

			@current_pos.set(barb.pos.x, barb.pos.y)
		end
	end
	
	def draw_arrow(from, to)
		arrow_stroke_color = 150
		arrow_stroke_weight = 1
		offset_length = 30
		
		stroke arrow_stroke_color
		stroke_weight arrow_stroke_weight
		
		# puts "from = #{from.x}, #{from.y}"
		# puts "to = #{to.x}, #{to.y}"
		
		# Initial trig calculations for the arrow head
		adj = to.x - from.x
		# puts "adj = #{adj}"
		opp = to.y - from.y
		# puts "opp = #{opp}"
		angle = Math.atan(opp/adj)
 		# puts "angle = #{angle}"
		
		if adj>0 and opp<0.001 and opp>-0.001
			line_from = Point.new(from.x+offset_length, from.y)
			line_to = Point.new(to.x-offset_length, to.y)
		elsif adj<0 and opp<0.001 and opp>-0.001
			line_from = Point.new(from.x-offset_length, from.y)
			line_to = Point.new(to.x+offset_length, to.y)
		elsif adj<0.001 and adj>-0.001 and opp<0
			line_from = Point.new(from.x, from.y-offset_length)
			line_to = Point.new(to.x, to.y+offset_length)
		elsif adj<0.001 and adj>-0.001 and opp>0
			line_from = Point.new(from.x, from.y+offset_length)
			line_to = Point.new(to.x, to.y-offset_length)
		elsif adj>0 and opp<0
			line_from = Point.new(from.x+offset_length*(Math.cos(angle)).abs, from.y-offset_length*(Math.sin(angle)).abs)
			line_to = Point.new(to.x-offset_length*(Math.cos(angle)).abs, to.y+offset_length*(Math.sin(angle)).abs)
		elsif adj<0 and opp<0
			line_from = Point.new(from.x-offset_length*Math.cos(angle), from.y-offset_length*(Math.sin(angle)).abs)
			line_to = Point.new(to.x+offset_length*Math.cos(angle), to.y+offset_length*(Math.sin(angle)).abs)
		elsif adj<0 and opp>0
			line_from = Point.new(from.x-offset_length*Math.cos(angle), from.y+offset_length*(Math.sin(angle)).abs)
			line_to = Point.new(to.x+offset_length*Math.cos(angle), to.y-offset_length*(Math.sin(angle)).abs)
		elsif adj>0 and opp>0
			line_from = Point.new(from.x+offset_length*Math.cos(angle), from.y+offset_length*(Math.sin(angle)).abs)
			line_to = Point.new(to.x-offset_length*Math.cos(angle), to.y-offset_length*(Math.sin(angle)).abs)
		else
			puts "default arrow"
			line_from = from
			line_to = to
		end
		
		# Arrow head height and (center-to-edge) width
		arrow_height = 10
		arrow_width = 5
		
		# Draw a line from one point to the next.
		# line from.x, from.y, to.x, to.y
		line line_from.x, line_from.y, line_to.x, line_to.y
		
		# Draw the arrow head
		push_matrix
		# translate line_from.x+adj, line_from.y+opp
		translate line_to.x, line_to.y
		rotate calculate_rotation(adj, opp, angle)
		line 0, 0, arrow_width, -arrow_height
		line 0, 0, -arrow_width, -arrow_height
		pop_matrix
	end
	
	def calculate_rotation(adj, opp, angle)
		if opp<0.001 and opp>-0.001 and adj>0
			3*Math::PI/2
		elsif opp<0.001 and opp>-0.001 and adj<0
			Math::PI/2
		elsif adj<0.001 and adj>-0.001 and opp<0
			Math::PI
		elsif adj<0.001 and adj>-0.001 and opp>0
			0
		elsif angle < 0 and opp < 0
			3*Math::PI/2 - angle.abs
		elsif angle < 0 and opp > 0
			Math::PI/2 - angle.abs
		elsif opp < 0 and adj < 0
			Math::PI/2 + angle.abs
		else
			3*Math::PI/2 + angle.abs
		end
	end
	
	def save_image
		save 'test_diagram'
	end
end

# DanceDiagram.new :title => "DanceDiagram", :width => 700, :height => 700
DanceDiagram.new :title => "DanceDiagram", :width => 1200, :height => 1200
# DanceDiagram.new :title => "DanceDiagram", :width => 1600, :height => 1600

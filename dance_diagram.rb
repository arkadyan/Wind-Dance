require 'ruby-processing'
require 'point'
require 'wind_barb'
require 'arrow'


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
		# input_file = "test6.csv"
		# input_file = "test5.csv"
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
		step_multiplier = 40
		# step_multiplier = 60
		# step_multiplier = 80
		# step_multiplier = 100
		move_from_last_step_distance = 50
		
		# Render the starting terminal circle
		render_terminal_circle(@barbs.first.pos)
		
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
			
			# Render the final terminal circle
			render_terminal_circle(@barbs.last.pos)

			stroke barb_stroke_color
			stroke_weight barb_stroke_weight
			barb.render
			
			# Draw arrow from previous step to the new step
			Arrow.new(barb).render

			@current_pos.set(barb.pos.x, barb.pos.y)
		end
	end
	
	def render_terminal_circle(pos)
		terminal_circle_width = 15
		terminal_circle_weight = 1
		terminal_circle_color = 50
		
		stroke_weight terminal_circle_weight
		stroke terminal_circle_color
		
		ellipse pos.x, pos.y, terminal_circle_width, terminal_circle_width
	end
	
	def save_image
		save 'test_diagram'
	end
end

DanceDiagram.new :title => "DanceDiagram", :width => 700, :height => 700
# DanceDiagram.new :title => "DanceDiagram", :width => 1200, :height => 1200
# DanceDiagram.new :title => "DanceDiagram", :width => 1600, :height => 1600

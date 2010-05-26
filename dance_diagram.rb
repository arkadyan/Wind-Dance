require 'ruby-processing'
require 'point'
require 'wind_barb'
require 'arrow'


class DanceDiagram < Processing::App
	
	TERMINAL_CIRCLE_WIDTH = 15
	TERMINAL_CIRCLE_WEIGHT = 1
	TERMINAL_CIRCLE_COLOR = 50
	
	COMPASS_STROKE_COLOR = 0
	CARDINAL_LENGTH = 10
	CARDINAL_WEIGHT = 4
	INTERMEDIATE_LENGTH = 7
	INTERMEDIATE_WEIGHT = 2
	MINOR_LENGTH = 4
	MINOR_WEIGHT = 1
	
	BARB_STROKE_COLOR = 0
	BARB_STROKE_WEIGHT = 2
	# STEP_MULTIPLIER = 6
	# STEP_MULTIPLIER = 15
	STEP_MULTIPLIER = 40
	# STEP_MULTIPLIER = 60
	# STEP_MULTIPLIER = 80
	# STEP_MULTIPLIER = 100
	MOVE_FROM_LAST_STEP_DISTANCE = 50
	
	
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
		stroke COMPASS_STROKE_COLOR
		
		# Cardinal directions
		stroke_weight CARDINAL_WEIGHT
		render_opposite_compass_points CARDINAL_LENGTH, Math::PI/2
		
		# Intermediate directions
		stroke_weight INTERMEDIATE_WEIGHT
		render_opposite_compass_points INTERMEDIATE_LENGTH, Math::PI/4
		
		# Minor directions
		stroke_weight MINOR_WEIGHT
		render_opposite_compass_points MINOR_LENGTH, Math::PI/8
		render_opposite_compass_points MINOR_LENGTH, Math::PI/8 + Math::PI/4
		
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
		# Render the starting terminal circle
		render_terminal_circle(@barbs.first.pos)
		
		@barbs.each do |barb|
			new_x = @current_pos.x + barb.speed * STEP_MULTIPLIER * Math.cos(barb.direction_in_radians)
			new_y = @current_pos.y + barb.speed * STEP_MULTIPLIER * Math.sin(barb.direction_in_radians)

			barb.pos.x = new_x
			barb.pos.y = new_y
			
			# If the last barb was a step, move away from it in the same direction
			if barb.speed==0 and barb.previous_barb and barb.previous_barb.speed > 0
				barb.pos.x -= MOVE_FROM_LAST_STEP_DISTANCE*Math.cos((3*Math::PI-barb.previous_barb.direction_in_radians).abs)
				barb.pos.y += MOVE_FROM_LAST_STEP_DISTANCE*Math.sin((3*Math::PI-barb.previous_barb.direction_in_radians).abs)
			end
			
			# Render the final terminal circle
			render_terminal_circle(@barbs.last.pos)

			stroke BARB_STROKE_COLOR
			stroke_weight BARB_STROKE_WEIGHT
			barb.render
			
			# Draw arrow from previous step to the new step
			Arrow.new(barb).render

			@current_pos.set(barb.pos.x, barb.pos.y)
		end
	end
	
	def render_terminal_circle(pos)
		stroke_weight TERMINAL_CIRCLE_WEIGHT
		stroke TERMINAL_CIRCLE_COLOR
		
		ellipse pos.x, pos.y, TERMINAL_CIRCLE_WIDTH, TERMINAL_CIRCLE_WIDTH
	end
	
	def save_image
		save 'test_diagram'
	end
end

DanceDiagram.new :title => "DanceDiagram", :width => 700, :height => 700
# DanceDiagram.new :title => "DanceDiagram", :width => 1200, :height => 1200
# DanceDiagram.new :title => "DanceDiagram", :width => 1600, :height => 1600

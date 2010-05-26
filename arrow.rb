require 'ruby-processing'
require 'wind_barb'
require 'point'


class Arrow
	include Processing::Proxy
	
	ARROW_STROKE_COLOR = 150
	ARROW_STROKE_WEIGHT = 1

	# Arrow head height and (center-to-edge) width
	ARROW_HEIGHT = 10
	ARROW_WIDTH = 5
	
	OFFSET_LENGTH = 30
	
	STARTING_DISTANCE_OUT = 13
	DISTANCE_OUT_OFFSET = 3
	MIDDLE_DISTANCE_BUMP = 1.2
	
	
	def initialize(to_barb)
		@to_barb = to_barb
		@from_barb = to_barb.previous_barb
	end
	
	
	def render
		if @to_barb.speed > 0
			render_to_step_barb
		else
			# Only display a calm arrow if there was a previous calm step,
			# and it wasn't in the same direction
			if @from_barb && @from_barb.speed==0 && @from_barb.direction != @to_barb.direction
				render_to_calm_barb
			end
		end
	end
	
	
	private
	
	def render_to_step_barb
		stroke ARROW_STROKE_COLOR
		stroke_weight ARROW_STROKE_WEIGHT
		
		# Initial trig calculations for the arrow head
		adj = @to_barb.pos.x - @from_barb.pos.x
		opp = @to_barb.pos.y - @from_barb.pos.y
		angle = Math.atan(opp/adj)
		
		if adj>0 and opp<0.001 and opp>-0.001
			line_from = Point.new(@from_barb.pos.x+OFFSET_LENGTH, @from_barb.pos.y)
			line_to = Point.new(@to_barb.pos.x-OFFSET_LENGTH, @to_barb.pos.y)
		elsif adj<0 and opp<0.001 and opp>-0.001
			line_from = Point.new(@from_barb.pos.x-OFFSET_LENGTH, @from_barb.pos.y)
			line_to = Point.new(@to_barb.pos.x+OFFSET_LENGTH, @to_barb.pos.y)
		elsif adj<0.001 and adj>-0.001 and opp<0
			line_from = Point.new(@from_barb.pos.x, @from_barb.pos.y-OFFSET_LENGTH)
			line_to = Point.new(@to_barb.pos.x, @to_barb.pos.y+OFFSET_LENGTH)
		elsif adj<0.001 and adj>-0.001 and opp>0
			line_from = Point.new(@from_barb.pos.x, @from_barb.pos.y+OFFSET_LENGTH)
			line_to = Point.new(@to_barb.pos.x, @to_barb.pos.y-OFFSET_LENGTH)
		elsif adj>0 and opp<0
			line_from = Point.new(@from_barb.pos.x+OFFSET_LENGTH*(Math.cos(angle)).abs, @from_barb.pos.y-OFFSET_LENGTH*(Math.sin(angle)).abs)
			line_to = Point.new(@to_barb.pos.x-OFFSET_LENGTH*(Math.cos(angle)).abs, @to_barb.pos.y+OFFSET_LENGTH*(Math.sin(angle)).abs)
		elsif adj<0 and opp<0
			line_from = Point.new(@from_barb.pos.x-OFFSET_LENGTH*Math.cos(angle), @from_barb.pos.y-OFFSET_LENGTH*(Math.sin(angle)).abs)
			line_to = Point.new(@to_barb.pos.x+OFFSET_LENGTH*Math.cos(angle), @to_barb.pos.y+OFFSET_LENGTH*(Math.sin(angle)).abs)
		elsif adj<0 and opp>0
			line_from = Point.new(@from_barb.pos.x-OFFSET_LENGTH*Math.cos(angle), @from_barb.pos.y+OFFSET_LENGTH*(Math.sin(angle)).abs)
			line_to = Point.new(@to_barb.pos.x+OFFSET_LENGTH*Math.cos(angle), @to_barb.pos.y-OFFSET_LENGTH*(Math.sin(angle)).abs)
		elsif adj>0 and opp>0
			line_from = Point.new(@from_barb.pos.x+OFFSET_LENGTH*Math.cos(angle), @from_barb.pos.y+OFFSET_LENGTH*(Math.sin(angle)).abs)
			line_to = Point.new(@to_barb.pos.x-OFFSET_LENGTH*Math.cos(angle), @to_barb.pos.y-OFFSET_LENGTH*(Math.sin(angle)).abs)
		else
			puts "default arrow"
			line_from = @from_barb.pos
			line_to = @to_barb.pos
		end
		
		# Draw a line from one point to the next.
		line line_from.x, line_from.y, line_to.x, line_to.y
		
		# Draw the arrow head
		push_matrix
		translate line_to.x, line_to.y
		rotate calculate_rotation(adj, opp, angle)
		line 0, 0, ARROW_WIDTH, -ARROW_HEIGHT
		line 0, 0, -ARROW_WIDTH, -ARROW_HEIGHT
		pop_matrix
	end
	
	def render_to_calm_barb
		distance_out = STARTING_DISTANCE_OUT + num_previous_calm_steps(@to_barb)*DISTANCE_OUT_OFFSET
		
		stroke ARROW_STROKE_COLOR
		stroke_weight ARROW_STROKE_WEIGHT

		from_direction = @from_barb.direction_in_radians
		to_direction = @to_barb.direction_in_radians
		middle_direction_1 = from_direction+(to_direction-from_direction)/3
		middle_direction_2 = from_direction+(to_direction-from_direction)*2/3
		
		
		from_point = Point.new(distance_out*Math.cos(from_direction)+@to_barb.pos.x, distance_out*Math.sin(from_direction)+@to_barb.pos.y)
		to_point = Point.new(distance_out*Math.cos(to_direction)+@to_barb.pos.x, distance_out*Math.sin(to_direction)+@to_barb.pos.y)
		middle_point_1 = Point.new((distance_out*MIDDLE_DISTANCE_BUMP)*Math.cos(middle_direction_1)+@to_barb.pos.x, (distance_out*MIDDLE_DISTANCE_BUMP)*Math.sin(middle_direction_1)+@to_barb.pos.y)		
		middle_point_2 = Point.new((distance_out*MIDDLE_DISTANCE_BUMP)*Math.cos(middle_direction_2)+@to_barb.pos.x, (distance_out*MIDDLE_DISTANCE_BUMP)*Math.sin(middle_direction_2)+@to_barb.pos.y)		
		
		
		bezier from_point.x, from_point.y, middle_point_1.x, middle_point_1.y, middle_point_2.x, middle_point_2.y, to_point.x, to_point.y
		
		# Draw the arrow head
		
		# Get the location of the final point
		arrow_x = bezierPoint(from_point.x, middle_point_1.x, middle_point_2.x, to_point.x, 1)
		arrow_y = bezierPoint(from_point.y, middle_point_1.y, middle_point_2.y, to_point.y, 1)
		
		# Get the tangent points
		arrow_tan_x = bezierTangent(from_point.x, middle_point_1.x, middle_point_2.x, to_point.x, 1)
		arrow_tan_y = bezierTangent(from_point.y, middle_point_1.y, middle_point_2.y, to_point.y, 1)
		
		# Calculate an angle from the tangent points
		arrow_angle = Math.atan2(arrow_tan_y, arrow_tan_x)
		arrow_angle += Math::PI
		
		# Draw the arrow head
		line(arrow_x, arrow_y, Math.cos(arrow_angle)*10 + arrow_x, Math.sin(arrow_angle)*10 + arrow_y);
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
	
	def num_previous_calm_steps(current_barb)
		previous_calm_steps = 0
		previous_barb = current_barb.previous_barb
		
		if previous_barb && previous_barb.speed==0
			previous_calm_steps += 1
			previous_calm_steps += num_previous_calm_steps(previous_barb)
		end
		
		previous_calm_steps
	end
end

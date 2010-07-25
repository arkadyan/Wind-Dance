require 'ruby-processing'
require 'point'


class WindBarb
	include Processing::Proxy
	
	attr_accessor :speed, :direction, :pos, :previous_barb
	
	BARB_STROKE_COLOR = 0
	BARB_STROKE_WEIGHT = 2

	MAIN_LINE_LENGTH = 30
	DOT_WIDTH = 3
	CIRCLE_WIDTH = 20

	# Arrow head height and (center-to-edge) width
	ARROW_LINE_LENGTH = 30
	ARROW_HEAD_HEIGHT = 8
	ARROW_HEAD_WIDTH = 4
	ARROW_STROKE_COLOR = 50
	ARROW_STROKE_WEIGHT = 1
	ARROW_DOT_WIDTH = 2
	ARROW_DOT_OFFSET = 5
	
	

	def initialize(speed, direction, previous_barb)
		@pos = Point.new(width/2, height/2)
		
		@speed = speed.to_f
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
		if @speed == 0
			render_calm
		else
			render_step
		end
	end
	
	
	private
	
	def render_calm
		stroke ARROW_STROKE_COLOR
		stroke_weight ARROW_STROKE_WEIGHT
				
		# Draw center dot
		fill 0
		ellipse @pos.x, @pos.y, DOT_WIDTH, DOT_WIDTH
		
		# Draw outer circle
		no_fill
		ellipse @pos.x, @pos.y, CIRCLE_WIDTH, CIRCLE_WIDTH
		
		push_matrix
		translate @pos.x, @pos.y
		rotate 3*Math::PI/2 + direction_in_radians
		
		# Draw the barb arrow
		stroke BARB_STROKE_COLOR
		stroke_weight BARB_STROKE_WEIGHT
		
		# Draw the arrow line
		line 0, 0, 0, ARROW_LINE_LENGTH
		
		# Draw the arrow head
		# line 0, ARROW_LINE_LENGTH, -ARROW_HEAD_WIDTH, ARROW_LINE_LENGTH-ARROW_HEAD_HEIGHT
		# line 0, ARROW_LINE_LENGTH, ARROW_HEAD_WIDTH, ARROW_LINE_LENGTH-ARROW_HEAD_HEIGHT
		
		# Draw a single dot above the arrow for the first step in a sequence
		if !@previous_barb || @previous_barb.speed>0
			fill 0
			ellipse 0, ARROW_LINE_LENGTH+ARROW_DOT_OFFSET, ARROW_DOT_WIDTH, ARROW_DOT_WIDTH
		end
		
		# Draw a double dot above the arrow for the final step in a sequence
		
		pop_matrix
	end
	
	def render_step
		stroke BARB_STROKE_COLOR
		stroke_weight BARB_STROKE_WEIGHT
		
		from_point = Point.new(@pos.x - (MAIN_LINE_LENGTH/2)*Math.cos(direction_in_radians), pos.y - (MAIN_LINE_LENGTH/2)*Math.sin(direction_in_radians))
		to_point = Point.new(from_point.x+MAIN_LINE_LENGTH*Math.cos(direction_in_radians), from_point.y+MAIN_LINE_LENGTH*Math.sin(direction_in_radians))
		
		line from_point.x, from_point.y, to_point.x, to_point.y

		render_barbs(from_point, MAIN_LINE_LENGTH, @speed)
	end
	
	def render_barbs(from_point, length, speed)
		full_flag_length = 20
		flag_length = 0
		flag_offset = 5
		flag_angle = 3*Math::PI/8
		to_point = Point.new(from_point.x+length*Math.cos(direction_in_radians), from_point.y+length*Math.sin(direction_in_radians))
		
		# If there is greater than 1 left for the speed 
		# draw a full flag and recurse
		# if there is less than 1, draw a half flag.
		if speed/2 > 1
			render_barbs(from_point, length-flag_offset, speed%2)
			flag_length = full_flag_length
		else
			flag_length = full_flag_length * 0.5
		end
		
		# Draw a flag
		push_matrix
		translate to_point.x, to_point.y
		rotate direction_in_radians + flag_angle
		line 0, 0, flag_length, 0
		pop_matrix
	end
end

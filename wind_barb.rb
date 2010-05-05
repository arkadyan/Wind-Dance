require 'ruby-processing'
require 'point'


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
	
	
	private
	
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

		from_point = Point.new(@pos.x - (main_line_length/2)*Math.cos(direction_in_radians), pos.y - (main_line_length/2)*Math.sin(direction_in_radians))
		# to_point = Point.new(@pos.x + (main_line_length/2)*Math.cos(direction_in_radians), pos.y + (main_line_length/2)*Math.sin(direction_in_radians))
		to_point = Point.new(from_point.x+main_line_length*Math.cos(direction_in_radians), from_point.y+main_line_length*Math.sin(direction_in_radians))
		
		line from_point.x, from_point.y, to_point.x, to_point.y

		puts "starting with speed=#{speed}"
		render_barbs(from_point, main_line_length, @speed)
	end
	
	def render_barbs(from_point, length, speed)
		full_flag_length = 20
		flag_length = 0
		flag_offset = 5
		flag_angle = 3*Math::PI/8
		to_point = Point.new(from_point.x+length*Math.cos(direction_in_radians), from_point.y+length*Math.sin(direction_in_radians))
		
		puts "speed=#{speed}"
		
		# If there is greater than 1 left for the speed 
		# draw a full flag and recurse
		# if there is less than 1, draw a half flag.
		if speed/2 > 1
			puts "if remainder=#{speed%2}"
			render_barbs(from_point, length-flag_offset, speed%2)
			flag_length = full_flag_length
		else
			puts "else remainder=#{speed%2}"
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

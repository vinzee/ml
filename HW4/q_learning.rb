# require 'gruff'
DIRECTIONS = {LEFT: 0, RIGHT: 1, UP: 2, DOWN: 3}
DIRECTIONS_1 = {0 => :LEFT, 1 => :RIGHT, 2 => :UP, 3 => :DOWN}
$learning_rate = 0.5
$discount_rate = 0.8
episodes = 1000

$grid_size = 15

init_value = 0 # rand(100...1000)
$q_table = Array.new($grid_size) { Array.new($grid_size) { Array.new(4){ init_value } } }
$reward_table = Array.new($grid_size) { Array.new($grid_size) { Array.new(4){ -1 } } }

def print_q_table
	DIRECTIONS.each do |k,v|
		puts "----------#{k}-----------"
		$q_table.each do |row|
			row.each do |col|
				printf "%5s ", col[v].round(3)
			end
			puts ""
		end		
	end
end

def get_next_action(current_state)
	if has_same_q_values?(current_state)
		rand(4) # pick a random action  # DIRECTIONS[:RIGHT]
	else
		get_q_max_value(current_state)
	end
end

def get_next_state(current_state, action)
	case (DIRECTIONS_1[action])
		when :UP
			next_state = [current_state[0]-1,current_state[1]]
		when :DOWN
			next_state = [current_state[0]+1,current_state[1]]
		when :LEFT
			next_state = [current_state[0],current_state[1]-1]
		when :RIGHT
			next_state = [current_state[0],current_state[1]+1]
		else
			raise RuntimeError, "Invalid direction #{action}"
	end

	if next_state[0] >= $grid_size || next_state[1] >= $grid_size || next_state[0] < 0 || next_state[1] < 0 # dashed a wall
		current_state
	else
		next_state
	end
end

def init_rewards
	$grid_size.times {|i| $reward_table[0][i][DIRECTIONS[:UP]] = -2 }
	$grid_size.times {|i| $reward_table[$grid_size-1][i][DIRECTIONS[:DOWN]] = -2 }
	$grid_size.times {|i| $reward_table[i][0][DIRECTIONS[:LEFT]] = -2 }
	$grid_size.times {|i| $reward_table[i][$grid_size-1][DIRECTIONS[:RIGHT]] = -2 }
	$reward_table[$grid_size-2][$grid_size-1][DIRECTIONS[:DOWN]] = 10
	$reward_table[$grid_size-1][$grid_size-2][DIRECTIONS[:RIGHT]] = 10
	# 4.times {|i| $reward_table[$grid_size-1][$grid_size-1][i] = 0 }
end

def get_reward(state, action)
	$reward_table[state[0]][state[1]][action]
end

def get_q_max_value(state)
	max_action_value = get_q_max(state)
	$q_table[state[0]][state[1]].index(max_action_value)
end

def get_q_max(state)
	$q_table[state[0]][state[1]].max
end

def has_same_q_values?(state)
	$q_table[state[0]][state[1]].uniq.length == 1
end

def get_q_value(state, action)
	$q_table[state[0]][state[1]][action]
end

def set_q_value(state, action, value)
	$q_table[state[0]][state[1]][action] = value; nil
end

init_rewards()
array_of_steps = []
# p $reward_table
episodes.times do |episode|
	current_state = [0,0]
	steps = 0
	while(current_state != [$grid_size-1,$grid_size-1])
		action = get_next_action(current_state)
		next_state = get_next_state(current_state, action)	
		# puts "#{current_state} + #{DIRECTIONS_1[action]} = #{next_state}"
		old_q_value = get_q_value(current_state, action)

		# puts "old_q_value #{old_q_value}"
		discounted_future_reward = $discount_rate * get_q_max(next_state)
		immediate_reward = get_reward(current_state, action)
		delta = immediate_reward + discounted_future_reward - old_q_value
		# puts "delta: #{delta} = #{immediate_reward} + #{discounted_future_reward} - #{old_q_value}"
		new_q_value = old_q_value + ($learning_rate * delta)
		# puts "new_q_value: #{new_q_value}"
		set_q_value(current_state, action, new_q_value)
		
		current_state = next_state
		# puts "----------------------------------"
		steps += 1
		# break if steps > 1000
	end
	array_of_steps << steps
	puts "#{steps}"
end

# print_q_table

# g = Gruff::Bezier.new
# g.title = 'Q-Learning with q_table initialized to 0'
# g.data 'Steps', array_of_steps
# g.minimum_value = 0
# g.write("q_learning.png")
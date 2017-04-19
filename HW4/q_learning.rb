DIRECTIONS = {LEFT: 0, RIGHT: 1, UP: 2, DOWN: 3}
DIRECTIONS_1 = {0 => :LEFT, 1 => :RIGHT, 2 => :UP, 3 => :DOWN}
$learning_rate = 0.5
$discount_rate = 0.8
$exploration_threshold = 0.5
episodes = 1000

# $q_table = Array.new(225) { Array.new(4){ rand(0...100) } }
$q_table = Array.new(225) { Array.new(4){ 0 } }
$reward_table = Array.new(225) { Array.new(4){ 0 } }

def get_next_action(current_state)
	if rand < $exploration_threshold || has_same_q_values?(current_state)
		action = rand(4) # pick a random action
	else
		action = get_q_max(current_state)
	end

	# DIRECTIONS_1[action]
	action
end

def get_next_state(current_state, action)
	reward = $reward_table[current_state][action]
	if reward == -1
		return current_state
	else
		case (DIRECTIONS_1[action])
			when :UP
				return current_state - 15
			when :DOWN
				return current_state + 15
			when :LEFT
				return current_state - 1
			when :RIGHT
				return current_state + 1
			else
				return current_state
		end
	end
end

def init_rewards
	set_penalty(0, 15, 1, DIRECTIONS[:UP])
	set_penalty(225 - 15, 225, 1, DIRECTIONS[:DOWN])
	set_penalty(0, (225 - 15) + 1, 15, DIRECTIONS[:LEFT])
	set_penalty(15 - 1, 225, 15, DIRECTIONS[:RIGHT])
	4.times {|i| $reward_table[225 - 1][i] = 100 }
end

def set_penalty(start_i, end_i, incremnet, action)
	i = start_i

	while(i < end_i) do
		$reward_table[i][action] = -1
		i = i + incremnet
	end
end

def get_reward(state, action)
	$reward_table[state][action]
end

def get_q_max(state)
	max_action_value = $q_table[state].max
	$q_table[state].index(max_action_value)
end

def has_same_q_values?(state)
	$q_table[state].uniq.length == 1
end

def get_q_value(state, action)
	$q_table[state][action]
end

def set_q_value(state, action, value)
	$q_table[state][action] = value; nil
end


init_rewards()
# p $reward_table


episodes.times do |episode|
	current_state = 0
	steps = 0
	while(current_state != 224)
		action = get_next_action(current_state)
		# action = DIRECTIONS[_action]
		next_state = get_next_state(current_state, action)	

		discounted_reward = $discount_rate * get_q_max(next_state)
		temp = discounted_reward
				+ get_reward(current_state, action)
				- get_q_value(current_state, action)
		value = get_q_value(current_state, action)
				+ ($learning_rate * temp)
		set_q_value(current_state, action, value)
		
		current_state = next_state

		# puts "current_state: #{current_state}"
		steps += 1
	end
	puts "#{episode} - #{steps}"
end

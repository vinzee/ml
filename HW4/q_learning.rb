require 'gruff'

DIRECTIONS = {LEFT: 0, RIGHT: 1, UP: 2, DOWN: 3}
DIRECTIONS_1 = {0 => :LEFT, 1 => :RIGHT, 2 => :UP, 3 => :DOWN}

class QLearner
	attr_accessor :init_value, :grid_size, :episodes, :learning_rate, :discount_rate, :q_table, :reward_table 

	def initialize(i = 0, gs = 15, e = 1000, lr = 0.5, dr = 0.8)
		self.init_value = i
		self.grid_size = gs
		self.episodes = e
		self.learning_rate = lr
		self.discount_rate = dr

		self.q_table = Array.new(self.grid_size) { Array.new(self.grid_size) { Array.new(4){ init_value } } }
		self.reward_table = Array.new(self.grid_size) { Array.new(self.grid_size) { Array.new(4){ -1 } } }

		init_rewards()
	end


	def print_q_table
		DIRECTIONS.each do |k,v|
			puts "----------#{k}-----------"
			self.q_table.each do |row|
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

		if next_state[0] >= self.grid_size || next_state[1] >= self.grid_size || next_state[0] < 0 || next_state[1] < 0 # dashed a wall
			current_state
		else
			next_state
		end
	end

	def init_rewards
		# self.grid_size.times {|i| self.reward_table[0][i][DIRECTIONS[:UP]] = -2 }
		# self.grid_size.times {|i| self.reward_table[self.grid_size-1][i][DIRECTIONS[:DOWN]] = -2 }
		# self.grid_size.times {|i| self.reward_table[i][0][DIRECTIONS[:LEFT]] = -2 }
		# self.grid_size.times {|i| self.reward_table[i][self.grid_size-1][DIRECTIONS[:RIGHT]] = -2 }
		self.reward_table[self.grid_size-2][self.grid_size-1][DIRECTIONS[:DOWN]] = 10
		self.reward_table[self.grid_size-1][self.grid_size-2][DIRECTIONS[:RIGHT]] = 10
	end

	def get_reward(state, action)
		self.reward_table[state[0]][state[1]][action]
	end

	def get_q_max_value(state)
		max_action_value = get_q_max(state)
		self.q_table[state[0]][state[1]].index(max_action_value)
	end

	def get_q_max(state)
		self.q_table[state[0]][state[1]].max
	end

	def has_same_q_values?(state)
		self.q_table[state[0]][state[1]].uniq.length == 1
	end

	def get_q_value(state, action)
		self.q_table[state[0]][state[1]][action]
	end

	def set_q_value(state, action, value)
		self.q_table[state[0]][state[1]][action] = value; nil
	end

	def run
		all_steps = []
		episodes.times do |episode|
			current_state = [0,0]
			steps = 0
			while(current_state != [self.grid_size-1,self.grid_size-1])
				action = get_next_action(current_state)
				next_state = get_next_state(current_state, action)
				old_q_value = get_q_value(current_state, action)

				discounted_future_reward = self.discount_rate * get_q_max(next_state)
				immediate_reward = get_reward(current_state, action)
				delta = immediate_reward + discounted_future_reward - old_q_value
				new_q_value = old_q_value + (self.learning_rate * delta)
				set_q_value(current_state, action, new_q_value)

				current_state = next_state
				steps += 1
			end
			all_steps << steps
			puts "#{steps}"
		end
		# print_q_table
		all_steps
	end

	def self.print_graph(steps_for_0, steps_for_random, random_value)
		g = Gruff::Line.new
		g.title = 'Q-Learning'
		g.data "Q_table_init: 0", steps_for_0
		g.data "Q_table init: #{random_value}", steps_for_random
		g.minimum_value = 0
		# g.line_width = 2
		g.write("q_learning.png")
	end
end

random_value = rand(100...1000)
steps_for_0 = QLearner.new().run
steps_for_random = QLearner.new().run

QLearner.print_graph(steps_for_0, steps_for_random, random_value)
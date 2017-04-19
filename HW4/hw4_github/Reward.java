import java.util.Arrays;

public class Reward {

	int rewardTable[][];
	int gridSize;
	public static final int LEFT =0;
	public static final int RIGHT =1;
	public static final int UP =2;
	public static final int DOWN =3;

	/**
	 * If action hits walls returns same state else returns state as per action
	 * @param state  - from state
	 * @param action - action performed 
	 * @return
	 */
	int getNextState(int state, int action) {
		int reward = rewardTable[state][action];
		if (reward == -1) {
			return state;
		} else {
			switch (action) {
			case UP:
				return state - 15;
			case DOWN:
				return state + 15;
			case LEFT:
				return state - 1;
			case RIGHT:
				return state + 1;
			default:
				return state;
			}
		}
	}

	/**
	 * Sets penalty for hitting wall of grid world
	 * 
	 * @param startIndex
	 * @param endIndex
	 * @param incremnet
	 * @param action
	 */
	void setPenalty(int startIndex, int endIndex, int incremnet, int action) {
		for (int i = startIndex; i < endIndex; i = i + incremnet)
			rewardTable[i][action] = -1;
	}

	/**
	 * generates reward tables by following cretrian if action hits wall reward
	 * =-1 for final state 100 0 else
	 * 
	 * @param states
	 *            total number of possible states works only for N*N grid
	 */
	void initRewards(int states) {

		System.out.println("---------------------------");
		for(int i = 0;i<rewardTable.length;i++)
			System.out.println(Arrays.toString(rewardTable[i]));
		System.out.println("---------------------------");

		/*
		 * setPenalty(0, 15, 1, Constants.UP); setPenalty(210, 225, 1,
		 * Constants.DOWN); setPenalty(0, 211, 15, Constants.LEFT);
		 * setPenalty(14, 225, 15, Constants.RIGHT);
		 */
		int gridRows = (int) Math.sqrt(states);
		setPenalty(0, gridRows, 1, UP);
		setPenalty(states - gridRows, states, 1, DOWN);
		setPenalty(0, (states - gridRows) + 1, gridRows, LEFT);
		setPenalty(gridRows - 1, states, gridRows, RIGHT);
		for (int i = 0; i < 4; i++)
			rewardTable[states - 1][i] = 100;
		
		System.out.println("---------------------------");
		for(int i = 0;i<rewardTable.length;i++)
			System.out.println(Arrays.toString(rewardTable[i]));
		System.out.println("---------------------------");
	}

	/**
	 * Returns reward value for specific state and action
	 * 
	 * @param state
	 *            - from state
	 * @param action
	 *            - action performed (our case left right up down)
	 * @return
	 */
	int getReward(int state, int action) {
		return rewardTable[state][action];
	}

	public Reward(int states, int actions) {
		rewardTable = new int[states][actions];
		gridSize = (int) Math.sqrt((double) states);
	}

}

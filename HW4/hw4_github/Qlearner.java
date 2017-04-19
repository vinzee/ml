import java.util.Arrays;

public class Qlearner {

	// default
	double learningRate = 0.5;
	double discountRate = 0.8;
	int episodes = 1000;
	
	public Qlearner(double alpha, double gamma, double itrations) {
		learningRate = alpha;
		discountRate = gamma;
		itrations = episodes;
	}

	public Qlearner() {

	}

	void learn(int States, int maxActionPerSatet, int percentNoise,double d,
			int startState, int finalState) {
		int counter = 0;
		Qtable q = new Qtable(States, maxActionPerSatet, percentNoise,d);
//		System.out.println(Arrays.asList(q));
		Reward r = new Reward(States, maxActionPerSatet);
		r.initRewards(States);
		do {
			int currentState = startState;
			int stepCounter = 0;
			do {
				int action = q.getNextAction(currentState);
				int nextState = r.getNextState(currentState, action);
				double discountedReward = q.getQmax(nextState) * discountRate;
				double teampSum = discountedReward
						+ r.getReward(currentState, action)
						- q.getQval(currentState, action);
				double value = q.getQval(currentState, action)
						+ (learningRate * teampSum);
				q.setQtableEntry(currentState, action, value);
				currentState = nextState;
				stepCounter++;
			} while (finalState != currentState);
//			System.err.println(counter + "," + stepCounter);
			counter++;
		} while (counter <= episodes);

	}

	public static void main(String[] args) {
		new Qlearner().learn(225, 4, 0,0.1, 0, 224);
	}

}

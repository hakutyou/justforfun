#!/usr/bin/env python3
# -*- coding: utf-8 -*-

from test import *
import gym


def run_maze():
        step = 0
        for episode in range(100):
                observation = env.reset()
                ep_r = 0

                while True:
                        env.render()
                        action = RL.choose_action(observation)
                        next_observation, reward, done, info = env.step(action)

                        position, velocity = next_observation

                        reward = abs(position - (-0.5))  # r in [0, 1]
                        RL.store_transition(observation, action, reward, next_observation)

                        ep_r += reward
                        if step > 1000:
                                RL.learn()

                        if done:
                                if next_observation[0] >= env.unwrapped.goal_position:
                                        get = '| Get'
                                else:
                                        get = '| ----'

                                print('Epi: ', episode, get,
                                      '| Ep_r: ', round(ep_r, 4),
                                      '| Epsilon: ', round(RL.epsilon, 2))
                                break
                        observation = next_observation
                        step += 1


if __name__ == '__main__':
        env = gym.make('MountainCar-v0')
        env = env.unwrapped

        print(env.action_space)
        print(env.observation_space)
        print(env.observation_space.high)
        print(env.observation_space.low)

        # env = Maze()
        RL = Test(n_actions=env.action_space.n, n_features=env.observation_space.shape[0],
                  learning_rate=0.001, e_greedy=0.99,
                  replace_target_iter=300, memory_size=3000, e_greedy_increment=0.0002)

        run_maze()
        # env.after(100, run_maze)
        # env.mainloop()
        RL.plot_cost()

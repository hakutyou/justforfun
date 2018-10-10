#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import numpy as np
import DQN


class Test:
        q_target = None
        q_eval = None
        q_next = None

        collection = None

        cost = 0
        memory_counter = 0

        def __init__(self, n_actions, n_features,
                     learning_rate=0.01, reward_decay=0.9, e_greedy=0.9,
                     replace_target_iter=300, memory_size=500, batch_size=32,
                     e_greedy_increment=None):
                self.n_actions = n_actions
                self.n_features = n_features
                self.lr = learning_rate
                self.gamma = reward_decay
                self.epsilon_max = e_greedy
                self.replace_target_iter = replace_target_iter
                self.memory_size = memory_size
                self.batch_size = batch_size
                self.epsilon_increment = e_greedy_increment
                self.epsilon = 0 if e_greedy_increment is not None else self.epsilon_max

                # total learning step
                self.learn_step_counter = 0

                # initialize zero memory [s, a, r, s_]
                self.memory = np.zeros((self.memory_size, n_features * 2 + 2))
                # feature, next_feature, action, reward

                self.dqn = DQN.QLearning.QLearning(learning_rate=self.lr)

                # eval net
                self.i, self.q_eval = self.dqn.build_net(
                        n_features, [1, 10],
                        cname='eval_net_params', folder='eval')
                _, self.target = self.dqn.build_net(None, [0, 0])
                self.regress = self.dqn.build_regress(
                        self.q_eval, n_actions, self.target, 'eval/regress')

                # target net
                self.target_i, self.q_next = self.dqn.build_net(
                        n_features, [1, 10],
                        cname='target_net_params', folder='target')
                self.dqn.build_graph(self.q_next, n_actions)

                # collection and init graph
                self.collection = self.dqn.init_graph(
                        collections=['target_net_params', 'eval_net_params'])

        def choose_action(self, observation):
                observation = observation[np.newaxis, :]  # reshape for tensorflow

                if np.random.uniform() < self.epsilon:
                        action_value = self.dqn.eval_graph(
                                {self.q_eval: None},
                                {self.i: {None: observation}})
                        return np.argmax(action_value)
                else:
                        return np.random.randint(0, self.n_actions)

        def store_transition(self, observation, action, reward, next_observation):
                transition = np.hstack((observation, [action, reward], next_observation))

                index = self.memory_counter % self.memory_size
                self.memory[index, :] = transition

                self.memory_counter += 1

        def learn(self):
                if self.learn_step_counter % self.replace_target_iter == 0:
                        self.dqn.eval_graph({self.collection: None})
                        print('\ntarget_params_replaced\n')

                if self.memory_counter > self.memory_size:
                        sample_index = np.random.choice(self.memory_size,
                                                        size=self.batch_size)
                else:
                        sample_index = np.random.choice(self.memory_counter,
                                                        size=self.batch_size)
                batch_memory = self.memory[sample_index, :]

                q_eval, q_next = self.dqn.eval_graph(
                        {self.q_eval: None, self.q_next: None},
                        {self.target_i: {None: batch_memory[:, -self.n_features:]},
                         self.i: {None: batch_memory[:, :self.n_features]}})
                q_target = q_eval.copy()
                batch_index = np.arange(self.batch_size, dtype=np.int32)
                eval_act_index = batch_memory[:, self.n_features].astype(int)
                reward = batch_memory[:, self.n_features + 1]

                q_target[batch_index, eval_act_index] = reward + self.gamma * np.max(
                        q_next, axis=1)

                # train eval network
                self.dqn.regress_graph(
                        self.regress,
                        {self.i: {None: batch_memory[:, :self.n_features]},
                         self.target: {None: q_target}})

                # increasing epsilon
                if self.epsilon < self.epsilon_max:
                        self.epsilon = self.epsilon + self.epsilon_increment
                else:
                        self.epsilon = self.epsilon_max
                self.learn_step_counter += 1

        def plot_cost(self):
                self.dqn.show_regress()
                return

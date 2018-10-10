# -*- coding: utf-8 -*-

__all__ = ('QLearning',
           )

import numpy as np
import matplotlib.pyplot as plt

from .NeuralNetwork import *


class Cost:
        cost_history = []

        def append(self, value):
                self.cost_history.append(value)
                return

        def show(self):
                print('cost: ', self.cost_history)
                plt.plot(np.arange(len(self.cost_history)), self.cost_history)
                plt.ylabel('Cost')
                plt.xlabel('training steps')
                plt.show()
                return


class QLearning:
        learning_rate = 0

        def __init__(self, learning_rate=0.01):
                self.learning_rate = learning_rate
                self.NN = NeuralNetwork()
                self.cost = Cost()

        def build_net(self, input_size, hidden, cname=None, folder=None):
                """
                build a base network.
                :param input_size: the size of input layer
                :param hidden: [the number of hidden layer,
                                the node of each hidden layer]
                                hidden_layer < 1, return input layer
                :param cname: name for collections
                :param folder: folder name contain network
                :return: output layer index
                """

                def layer_name(nr):
                        if folder is None:
                                return
                        return folder + '/l' + str(nr)

                [hidden_layer, hidden_size] = hidden
                input_node = self.NN.add_placeholder('input')
                if hidden_layer < 1:
                        return None, input_node

                l_in = self.NN.add_fc(
                        input_size, relu=True,
                        cname=cname, name=layer_name(0))
                self.NN.connect_node(input_node, l_in)
                for i in range(1, hidden_layer):
                        # hidden_layer times, start with 1
                        l_out = self.NN.add_fc(
                                hidden_size, relu=True,
                                cname=cname, name=layer_name(i))
                        self.NN.connect_node(l_in, l_out)
                        l_in = l_out

                output_node = self.NN.add_fc(
                        hidden_size, relu=False,
                        cname=cname, name=layer_name(hidden_layer))
                self.NN.connect_node(l_in, output_node)
                return input_node, output_node

        def build_regress(self, output_layer=0, output_size=None,
                          target_layer=None, name=None):
                """
                build a graph with regress.
                :param output_layer: output layer
                :param output_size: output layer size
                :param target_layer: target layer
                :param name: regress layer name
                :return: regress layer
                """
                if target_layer is None:
                        print('without target layer, nothing to do')
                        return

                regress = self.NN.add_regress(output_size,
                                              self.learning_rate, name)
                self.NN.connect_node(target_layer, regress)
                self.NN.connect_node(output_layer, regress)
                self.NN.build_graph(end_node=regress)
                return regress

        def build_graph(self, output_layer=0, output_size=None):
                """
                build a graph about generate output layer.
                :param output_layer: output layer
                :param output_size: output layer size
                :return: None
                """
                self.NN.build_graph(end_node=output_layer,
                                    end_size=output_size)

        def init_graph(self, collections=None):
                """
                when all graph built, run this
                :param collections: collections name list if have collection.
                :return: collections can be eval.
                """
                c = None
                self.NN.init_graph()  # will not display collection part
                if collections is not None:
                        c = self.NN.add_collection(collections)
                return c

        def eval_graph(self, raw_node, raw_feed=None):
                """
                eval node in graph.
                :param raw_node: {node: [node content key]}
                :param raw_feed: {feed node: {feed node content: feed value}}
                :return: node result
                """
                return self.NN.eval(raw_node, raw_feed)

        def regress_graph(self, regress_node, raw_feed=None):
                """
                calculate regress in graph.
                :param regress_node: regress node
                :param raw_feed: {feed node: {feed node content: feed value}}
                :return: None
                """
                _, cost_value = self.NN.eval(
                        {regress_node: [None, 'loss']}, raw_feed)

                self.cost.append(cost_value)
                return

        def show_regress(self):
                self.cost.show()
                return

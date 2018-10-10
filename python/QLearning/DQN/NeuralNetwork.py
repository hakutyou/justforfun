# -*- coding: utf-8 -*-

__all__ = ('NeuralNetwork',
           )

import tensorflow as tf


class Node:
        _node = []
        _count = -1

        def node(self, node_nr, attr):
                return self._node[node_nr][attr]

        def node_set(self, node_nr, attr, value, overwrite=False):
                node = self._node[node_nr]
                try:
                        if not overwrite:
                                node[attr] += value,
                        else:
                                node[attr] = value
                except KeyError:
                        node[attr] = value

        def node_add(self, **attr):
                self._node.append({
                        'connect': [],
                        'content': {},
                })
                self._count += 1
                for key in attr.keys():
                        self.node_set(self._count, key, attr[key])
                return self._count

        def content(self, node_nr, key=None):
                node = self.node(node_nr, 'content')
                return node[key if key is not None else 'default']

        def content_set(self, node_nr, key=None, value=None):
                node = self.node(node_nr, 'content')
                node[key if key is not None else 'default'] = value
                return value


class NeuralNetwork:
        # for learning
        loss = None
        train = None

        # tensorflow, tensorboard
        sess = None
        writer = None

        def __init__(self):
                self.n = Node()

        # head node
        def add_placeholder(self, name=None):
                return self.n.node_add(op='placeholder', name=name)

        # part/tail node
        def add_fc(self, size, relu=False, name=None, cname=None):
                """ 全连接层 """
                return self.n.node_add(op='fc', size=size,
                                       relu=relu, name=name, cname=cname)

        # tail node
        def add_regress(self, size, learning_rate=0.01, name=None):
                return self.n.node_add(op='regress', size=size,
                                       learning_rate=learning_rate,
                                       name=name)

        def add_collection(self, collections):
                params = list(map(lambda x: tf.get_collection(x),
                                  collections))
                node = self.n.node_add(collections=None)
                self.n.content_set(
                        node, None, [tf.assign(t, e) for t, e in zip(*params)])
                return node

        # graph line
        def connect_node(self, in_node, out_node):
                self.n.node_set(out_node, 'connect', in_node)
                return

        # build graph
        def build_graph(self, end_node=0, end_size=None):
                def node_fc(out_size, flow, in_node):
                        def w_init(value=0.1):
                                return tf.random_normal_initializer(0., value)

                        def b_init(value=0.1):
                                return tf.constant_initializer(value)

                        name, in_size, relu, cname = map(
                                lambda x: self.n.node(in_node, x),
                                ('name', 'size', 'relu', 'cname'))

                        w_name, b_name, r_name = map(
                                None if name is None else
                                lambda x: x + name.split('/')[-1],
                                ('w_', 'b_', 'relu_'))
                        c = [cname, tf.GraphKeys.GLOBAL_VARIABLES]

                        with tf.variable_scope(name):
                                weight = tf.get_variable(
                                        w_name, [in_size, out_size],
                                        initializer=w_init(.3), collections=c)
                                bias = tf.get_variable(
                                        b_name, [1, out_size],
                                        initializer=b_init(.1), collections=c)
                                flow = tf.matmul(flow, weight) + bias
                                if relu:
                                        flow = tf.nn.relu(flow, r_name)
                                return self.n.content_set(in_node, None, flow)

                def node_regress(flow_target, flow_eval, in_node):
                        name, learning_rate = map(
                                lambda x: self.n.node(in_node, x),
                                ('name', 'learning_rate'))
                        loss_name, train_name = map(
                                None if name is None else
                                lambda x: x + name.split('/')[-1],
                                ('loss_', 'train_'))
                        with tf.variable_scope(loss_name):
                                loss = tf.reduce_mean(
                                        tf.squared_difference(flow_target,
                                                              flow_eval))
                                self.n.content_set(in_node, 'loss', loss)
                        with tf.variable_scope(train_name):
                                train = tf.train.RMSPropOptimizer(
                                        learning_rate).minimize(loss)
                                return self.n.content_set(in_node, None, train)

                def map_recu(node):
                        return list(map(
                                lambda x: recu(x, self.n.node(node, 'size')),
                                self.n.node(node, 'connect')))

                def recu(in_node, out_size):
                        in_node_op = self.n.node(in_node, 'op')
                        in_node_name = self.n.node(in_node, 'name')

                        if in_node_op == 'placeholder':
                                return self.n.content_set(
                                        in_node, None, tf.placeholder(
                                                tf.float32, [None, out_size],
                                                in_node_name))
                        if in_node_op == 'fc':
                                [flow] = map_recu(in_node)
                                return self.n.content_set(
                                        in_node, None, node_fc(
                                                out_size, flow, in_node))

                end_node_op = self.n.node(end_node, 'op')
                if end_node_op == 'regress':
                        [q_target, q_eval] = map_recu(end_node)
                        q_regress = node_regress(q_target, q_eval, end_node)
                        self.n.content_set(end_node, None, q_regress)
                        self.n.content_set(end_node, 'target', q_target)
                        self.n.content_set(end_node, 'eval', q_eval)
                        return

                recu(end_node, end_size)
                return

        def init_graph(self):
                self.sess = tf.Session()
                self.writer = tf.summary.FileWriter('visualization/',
                                                    self.sess.graph)
                self.sess.run(tf.global_variables_initializer())
                return

        def eval(self, raw_node, raw_feed=None):
                if self.sess is None:
                        print('run init_graph() at first')
                        return

                raw_feed = raw_feed if raw_feed is not None else {}

                node_list = []
                for node, key in raw_node.items():
                        if type(key) != list:
                                key = [key]
                        for i in range(len(key)):
                                node_list.append(self.n.content(node, key[i]))

                feed_dict = {}
                for node, feed in raw_feed.items():
                        for key, value in feed.items():
                                feed_dict[self.n.content(node, key)] = value

                return self.sess.run(node_list, feed_dict=feed_dict)

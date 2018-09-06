import os
import numpy as np
import tensorflow as tf

class CNN:
    def __init__(self):
        pass

    @staticmethod
    def weight_variable(shape):
        initial = tf.truncated_normal(shape, stddev=0.1)
        return tf.Variable(initial)

    @staticmethod
    def bias_variable(shape):
        initial = tf.constant(0.1, shape=shape)
        return tf.Variable(initial)

    def layer_conv(self, flow, W_size, b_size, relu=True):
        W = self.weight_variable(W_size)
        b = self.weight_variable(b_size)
        flow = tf.nn.conv2d(flow, W, strides=[1,1,1,1],
                            padding='SAME') + b
        if relu:
            flow = tf.nn.relu(flow)
        return flow

    def layer_pool(self, flow):
        return tf.nn.max_pool(flow, ksize=[1,2,2,1],
                              strides=[1,2,2,1], padding='SAME')

    def layer_fc(self, flow, W_size, b_size, relu=True):
        W = self.weight_variable(W_size)
        b = self.weight_variable(b_size)
        flow = tf.matmul(flow, W) + b
        if relu:
            flow = tf.nn.relu(flow)
        return flow

    def build(self):
        self.x = tf.placeholder('float', shape=[None, 784])
        self.y = tf.placeholder('float', shape=[None, 10])

        flow = tf.reshape(self.x, [-1, 28, 28, 1]) # grey
        # CONV1
        flow = self.layer_conv(flow, [3,3,1,6], [6])
        flow = self.layer_pool(flow)
        # CONV2
        flow = self.layer_conv(flow, [3,3,6,16], [16])
        flow = self.layer_pool(flow)
        # FC1
        flow = tf.reshape(flow, [-1, 7*7*16])
        flow = self.layer_fc(flow, [7*7*16, 120], [120])
        # Dropout
        self.dropout_prob = tf.placeholder('float')
        flow = tf.nn.dropout(flow, self.dropout_prob)
        # FC2
        flow = self.layer_fc(flow, [120, 10], [10])
        self.pred_y = flow = tf.nn.softmax(flow)
        # learning
        cross_entropy = -tf.reduce_sum(self.y * tf.log(flow))
        self.train_step = tf.train.AdamOptimizer(1e-4).minimize(cross_entropy)
        correct_predict = tf.equal(tf.argmax(flow, 1), tf.argmax(self.y, 1))
        self.accuracy = tf.reduce_mean(tf.cast(correct_predict, 'float'))
        # saver
        self.saver = tf.train.Saver()

    def train(self):
        sess = tf.InteractiveSession()
        sess.run(tf.global_variables_initializer())

        checkpoint = tf.train.get_checkpoint_state(os.path.dirname(__file__))
        if checkpoint and checkpoint.model_checkpoint_path:
            self.saver.restore(sess, checkpoint.model_checkpoint_path)

        for i in range(20000):
            batch = mnist.train.next_batch(50)
            if i % 100 == 0:
                train_accuracy = self.accuracy.eval(feed_dict={
                    self.x:batch[0], self.y:batch[1], self.dropout_prob:1})
                print ('step %d, training accuracy %g' % (i, train_accuracy))
                self.saver.save(sess, './model.ckpt')
            self.train_step.run(feed_dict={self.x:batch[0], self.y:batch[1], self.dropout_prob:0.5})
        sess.close()

    def predict(self):
        sess = tf.InteractiveSession()
        sess.run(tf.global_variables_initializer())
        saver = tf.train.Saver(tf.global_variables())
        saver.restore(sess, './model.ckpt')
        print( "test accuracy %g" % self.accuracy.eval(feed_dict={
            self.x:mnist.test.images, self.y:mnist.test.labels, self.dropout_prob:1})) 
        sess.close()

    def read(self, input_image):
        sess = tf.InteractiveSession()
        sess.run(tf.global_variables_initializer())
        saver = tf.train.Saver(tf.global_variables())
        saver.restore(sess, './model.ckpt')
        output_number = self.pred_y.eval(feed_dict={self.x:[input_image], self.dropout_prob:1})       
        result = np.where(output_number==np.max(output_number))[1][0]
        sess.close()
        return result

if __name__ == '__main__':
    import input_data
    mnist = input_data.read_data_sets('MNIST_data', one_hot=True)
    cnn = CNN()
    cnn.build()
    cnn.train()
    cnn.predict()

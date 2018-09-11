import cnn
import numpy as np

if __name__ == '__main__':
    #import input_data
    import random
    from PIL import Image

    #mnist = input_data.read_data_sets('MNIST_data', one_hot=True)
    ocr = cnn.CNN()
    ocr.build()

    #ocr.predict()

    show_image2 = Image.open('G:/Users/kakoi/Desktop/无标题.bmp')
    show_array2 = np.asarray(show_image2).flatten()
    input_image2 = show_array2 / 255
    print(ocr.read(input_image2))
    
    #input_image = mnist.test.images[random.randrange(0, 100)]
    #show_image = input_image*255
    #im = Image.fromarray(show_image.reshape([28,28]))
    #im.show()
    #print(ocr.read(input_image))

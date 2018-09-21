import numpy as np
import cv2
from matplotlib import pyplot as plt

img = cv2.imread('test.jpg')
if img is None:
        print('No such image.')
else:
        gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)

        corners = cv2.goodFeaturesToTrack(gray, 25, 0.01, 10)
        points = np.int0(corners)

        print(corners)
        for i in points:
                x, y = i.ravel()
                print(x, y)
                cv2.circle(img, (x, y), 3, 255, -1)

        cv2.imshow('dst', img)
        cv2.waitKey(0)

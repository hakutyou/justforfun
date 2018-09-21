import numpy as np
import cv2

img = cv2.imread('test.jpg')
if img is None:
        print('No such image.')
else:
        gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)

        gray = np.float32(gray)
        dst = cv2.cornerHarris(gray, 2, 3, 0.04)

        dst = cv2.dilate(dst, None)

        cv2.imshow('dst', img)
        img[dst > 0.01*dst.max()] = [0, 0, 255]
        cv2.waitKey(0)
        cv2.imshow('dst', img)

        if cv2.waitKey(0) == 27:
                cv2.destroyAllWindows()

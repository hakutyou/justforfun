import numpy as np
import cv2

img = cv2.imread('test.jpg')
if img is None:
        print('No such image.')
else:
        gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)

        # find Harrirs corners
        gray = np.float32(gray)
        dst = cv2.cornerHarris(gray, 2, 3, 0.04)

        dst = cv2.dilate(dst, None)
        # img[dst > 0.01*dst.max()] = [0, 0, 255]
        # cv2.imshow('dst', img)
        # if cv2.waitKey(0) == 27:
        #         cv2.destroyAllWindows()

        _, dst = cv2.threshold(dst, 0.01 * dst.max(), 255, 0)
        dst = np.uint8(dst)
        # find centroids
        ret, labels, stats, centroids = cv2.connectedComponentsWithStats(dst)

        # define the criteria to stop and refine the corners
        criteria = (cv2.TERM_CRITERIA_EPS + cv2.TERM_CRITERIA_MAX_ITER, 100, 0.001)
        corners = cv2.cornerSubPix(gray, np.float32(centroids), (5, 5), (-1, -1),
                                   criteria)

        # Now draw them
        res = np.hstack((centroids, corners))
        res = np.int0(res)
        img[res[:, 1], res[:, 0]] = [0, 0, 255]
        img[res[:, 3], res[:, 2]] = [0, 255, 0]

        cv2.imwrite('test_result.png', img)

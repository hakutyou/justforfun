# coding: utf-8
import cv2

imagepath = r'./test1.jpg'
face_cascade = cv2.CascadeClassifier(r'./haarcascade_frontalface_default.xml')

image = cv2.imread(imagepath)
gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)

faces = face_cascade.detectMultiScale(
        gray,
        scaleFactor=1.15,
        minNeighbors=5,
        minSize=(5, 5),
        flags=0
)

print("发现{0}个人脸!".format(len(faces)))

for (x, y, w, h) in faces:
        cv2.circle(image, (int((x + x + w) / 2),
                           int((y + y + h) / 2)), int(w / 2), (0, 255, 0), 2)

cv2.imshow("Result", image)

cv2.waitKey(0)
cv2.destroyAllWindows()

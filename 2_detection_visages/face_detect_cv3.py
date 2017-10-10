import os
import glob
import cv2
import sys

# Get user supplied values
imagePath = sys.argv[1]
cascPath = sys.argv[2]

# Create the haar cascade
faceCascade = cv2.CascadeClassifier(cascPath)

for filename in glob.glob(sys.argv[1]+'*.jpg'):
    baseName = os.path.basename(filename)
    #print filename
    #print baseName
    image = cv2.imread(filename)
    gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
    # Detect faces in the image
    faces = faceCascade.detectMultiScale(
        gray,
        minNeighbors=5
    )
    #print("Found {0} faces!".format(len(faces)))
    
    # Draw a rectangle around the faces
    i = 0
    for (x, y, w, h) in faces:
        i = i + 1
        cv2.imwrite("export/"+baseName+"_results_face_%005d.png" % i, image[y:y+h, x:x+w])
    
    for (x, y, w, h) in faces:
        cv2.rectangle(image, (x, y), (x+w, y+h), (0, 255, 0), 2)

    #cv2.imwrite("export/"+baseName+"_results.png", image)
#cv2.imshow("Faces found", image)
#cv2.waitKey(0)

#result = exec("python face_detect_cv3.py abba.png  haarcascade_frontalface_default.xml")

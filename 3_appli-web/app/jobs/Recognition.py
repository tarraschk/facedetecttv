import os
import glob
import cv2
import cv2.face
import sys
import math
import numpy
from PIL import Image



importPath = "/home/anis/PycharmProjects/untitled/export/"
exportPath = "/home/anis/PycharmProjects/untitled/exportFinal/"

candidatsPath = "/home/anis/PycharmProjects/untitled/Candidats/"

recognizer = cv2.face.createLBPHFaceRecognizer(threshold = 10.0)

labels=[]
images=[]
numbers=[]

i=-1
for path in glob.glob(candidatsPath+'*'):
    i=i+1
    labels.append(os.path.split(path)[1])
    for imagePath in glob.glob(path+'/*'):
        images.append(cv2.cvtColor(cv2.imread(imagePath), cv2.COLOR_BGR2GRAY))
        numbers.append(i)

recognizer.train(images, numpy.array(numbers))

k=-1
for imagePath in glob.glob(importPath+'*'):
    k=k+1
    image = cv2.cvtColor(cv2.imread(imagePath), cv2.COLOR_BGR2GRAY)
    numberPredicted, conf = recognizer.predict(image)

    if numberPredicted !=-1:
        cv2.imwrite(exportPath+labels[numberPredicted]+str(math.floor(conf))+"_%005d.jpg" % k, image)
    else:
        cv2.imwrite(exportPath + "Zinconnu" + str(math.floor(conf)) + "_%005d.jpg" % k, image)

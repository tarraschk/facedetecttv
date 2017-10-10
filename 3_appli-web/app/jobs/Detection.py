import os
import glob
import cv2
import sys
import math
import numpy
from PIL import Image


#Get user supplied value
#imagePath = sys.argv[1]
imagePath = "/home/anis/PycharmProjects/untitled/images/"
exportPath= "/home/anis/PycharmProjects/untitled/export/"

#Get path the haar cascades
cascPath = "/opt/opencv/data/haarcascades/haarcascade_frontalface_alt.xml"
cascPath2 = "/opt/opencv_contrib/modules/face/data/cascades/haarcascade_mcs_lefteye.xml"
cascPath3 = "/opt/opencv_contrib/modules/face/data/cascades/haarcascade_mcs_righteye.xml"


#Distance between two points
def Distance(p1, p2):
    dx = p2[0] - p1[0]
    dy = p2[1] - p1[1]
    return math.sqrt(dx*dx+dy*dy)


#Translate, rotation and scaling of an image
def ScaleRotateTranslate(image, angle, center = None, new_center = None, scale = None, resample=Image.BICUBIC):
    if (scale is None) and (center is None):
        return image.rotate(angle=angle, resample=resample)
    nx, ny = x, y = center
    sx=sy=1.0
    if new_center:
        (nx, ny) = new_center
    if scale:
        (sx, sy) = (scale, scale)
    cosine = math.cos(angle)
    sine = math.sin(angle)
    a = cosine/sx
    b = sine/sx
    c = x-nx*a-ny*b
    d = -sine/sy
    e = cosine/sy
    f = y-nx*d-ny*e
    return image.transform(image.size, Image.AFFINE, (a, b, c, d, e, f), resample=resample)


#Cropping the face
def CropFace(image, eye_left=(0, 0), eye_right=(0, 0), offset_pct=(0.2, 0.2), dest_sz = (70, 70)):
    # calculate offsets in original image
    offset_h = math.floor(float(offset_pct[0])*dest_sz[0])
    offset_v = math.floor(float(offset_pct[1])*dest_sz[1])
    # get the direction
    eye_direction = (eye_right[0] - eye_left[0], eye_right[1] - eye_left[1])
    # calc rotation angle in radians
    rotation = -math.atan2(float(eye_direction[1]), float(eye_direction[0]))
    # distance between them
    dist = Distance(eye_left, eye_right)
    # calculate the reference eye-width
    reference = dest_sz[0] - 2.0*offset_h
    # scale factor
    scale = float(dist)/float(reference)
    # rotate original around the left eye
    image = ScaleRotateTranslate(image, center=eye_left, angle=rotation)
    # crop the rotated image
    crop_xy = (eye_left[0] - scale*offset_h, eye_left[1] - scale*offset_v)
    crop_size = (dest_sz[0]*scale, dest_sz[1]*scale)
    image = image.crop((int(crop_xy[0]), int(crop_xy[1]), int(crop_xy[0]+crop_size[0]), int(crop_xy[1]+crop_size[1])))
    # resize it
    image = image.resize(dest_sz, Image.ANTIALIAS)
    return image


#Detecting one left eye, or nothing
def DetectOneLeftEye(image, neib, length=-1):
    eyes = leftEyeCascade.detectMultiScale(image, 1.2, minNeighbors=neib)
    if len(eyes)>1 and length!=0:
        return DetectOneLeftEye(image, neib+1, 2)
    elif len(eyes)>1 and length == 0:
        for (ex, ey, ew, eh) in eyes:
            return(ex+ew/2, ey+eh/2)
    elif len(eyes) == 0 and neib > 0:
        return DetectOneLeftEye(image, neib-1, 0)
    elif len(eyes) == 1:
        for (ex, ey, ew, eh) in eyes:
            print(neib)
            return (ex + ew / 2, ey + eh / 2)
    else:
        return (0, 0)


#Detecting one right eye or nothing
def DetectOneRightEye(image, neib, length=-1):
    eyes = rightEyeCascade.detectMultiScale(image, 1.2, minNeighbors=neib)
    if len(eyes) > 1 and length != 0:
        return DetectOneRightEye(image, neib + 1, 2)
    elif len(eyes) > 1 and length == 0:
        for (ex, ey, ew, eh) in eyes:
            return (ex + ew / 2, ey + eh / 2)
    elif len(eyes) == 0 and neib > 0:
        return DetectOneRightEye(image, neib - 1, 0)
    elif len(eyes) == 1:
        for (ex, ey, ew, eh) in eyes:
            print (neib)
            return (ex + ew / 2, ey + eh / 2)
    else:
        return (0, 0)


# Create the haar cascades
faceCascade = cv2.CascadeClassifier(cascPath)
leftEyeCascade = cv2.CascadeClassifier(cascPath2)
rightEyeCascade = cv2.CascadeClassifier(cascPath3)

k=0
for filename in glob.glob(imagePath + '*.jpg'):
    k=k+1
    #loading the image in gray
    baseName = os.path.basename(filename)
    toBeCropped = Image.open(filename)
    toBeCropped = toBeCropped.convert('L')
    gray = numpy.array(toBeCropped)

    #Detect faces in the image
    faces = faceCascade.detectMultiScale(gray, 1.2, minNeighbors=3)

    #Save the (cropped if possible) face in export
    i = 0
    for (x, y, w, h) in faces:
        i = i + 1

        #Try to detect one right eye and one left eye
        roi_gray_left = gray[y:y + h, x:x + w/2]
        roi_gray_right = gray[y:y+h, x+w/2:x+w]

        coor = [(0, 0), (0, 0)]
        coor[0] = DetectOneLeftEye(roi_gray_left, 3)
        coor[1] = DetectOneRightEye(roi_gray_right, 3)

        #If one left eye and one right eye are detected, crop and save, else save the general outline of the face
        print(coor)
        if coor[0]!=(0, 0) and coor[1]!=(0, 0):
            coor[0] = (x + coor[0][0], y+coor[0][1])
            coor[1] = (x+w/2 + coor[1][0], y+coor[1][1])
            CropFace(toBeCropped, eye_left=coor[0], eye_right=coor[1], offset_pct=(0.3, 0.3), dest_sz=(100, 100)).save(exportPath + baseName + "_results_face_%005d.jpg" % i)
            #CropFace(toBeCropped, eye_left=coor[0], eye_right=coor[1], offset_pct=(0.3, 0.3), dest_sz=(100, 100)).save("export/Valls_results_face_%005d_%005d.jpg" % (k, i))

            #gray_face = cv2.resize(gray[y:y + h, x:x + w], (100, 100), interpolation=cv2.INTER_CUBIC)
            #cv2.imwrite("export/Valls_results_face_%005d_%005d_simple.jpg" % (k, i), gray_face)
        else:
            gray_face= cv2.resize(gray[y:y + h, x:x + w], (100, 100), interpolation=cv2.INTER_CUBIC)
            cv2.imwrite(exportPath + baseName + "_results_face__%005d_simple.jpg" % i, gray_face)
            #cv2.imwrite("export/Valls_results_face_%005d_%005d_simple.jpg" % (k, i), gray_face)

    toBeCropped.close()

            # result = exec("python face_detect_cv3.py /home/anis/PycharmProjects/untitled/images/)

import time

import cv2

filename = r'C:\Users\emrek\Desktop\Technical\Gallaudet\annotations\example.txt'
fname = filename.split('\\')[-1]
saveFolder = 'videos_annotated'
rawVidFolder = r'C:\Users\emrek\Desktop\Technical\Gallaudet\videos'
classFile = r'C:\Users\emrek\Desktop\Technical\Gallaudet\classes.txt'

if 'Exp2' in filename:
    expNum = 'exp2'
elif 'Exp3' in filename:
    expNum = 'exp3'
elif 'example' in filename:
    expNum = ''
else:
    raise FileNotFoundError(filename + ' is not a valid file.')

rawVidName = rawVidFolder + '\\' + expNum + '\\' + fname.replace('txt', 'mp4')
annotVidName = filename.replace('annotations', saveFolder + '\\' + expNum).replace('txt', 'mp4')

with open(classFile, 'r') as file:
    f = file.readlines()

classes = dict()
for line in f:
    classes[line.split(',')[0]] = line.split(',')[-1][1:-1]

with open(filename, 'r') as file:
    f = file.readlines()
del f[:3]

maxFrame = f[-1].split(',')[0]
indices = [line.split(',') for line in f]
indices = [[int(j) for j in i] for i in indices]

fps = 30
w, h = 640, 480
cap = cv2.VideoCapture(rawVidName)
fourcc = cv2.VideoWriter_fourcc('m', 'p', '4', 'v')
writer = cv2.VideoWriter(annotVidName, fourcc, fps, (w, h))
font = cv2.FONT_HERSHEY_SIMPLEX

while True:

    ret, frame = cap.read()

    # print('Frame: ' + str(int(cap.get(cv2.CAP_PROP_POS_FRAMES))) + '/' + str(int(cap.get(cv2.CAP_PROP_FRAME_COUNT))))
    print('Processing ... ' + str(int(cap.get(cv2.CAP_PROP_POS_FRAMES) / cap.get(cv2.CAP_PROP_FRAME_COUNT)) * 100) +
          '%')

    # Use putText() method for
    # inserting text on video
    cv2.putText(frame,
                'Frame Number:' + str(int(cap.get(cv2.CAP_PROP_POS_FRAMES))),
                (50, 50),
                font, 1,
                (0, 255, 255),
                2,
                cv2.LINE_4)

    # Display the resulting frame
    # cv2.imshow('video', frame)
    writer.write(frame)

    # creating 'q' as the quit
    # button for the video
    if cv2.waitKey(1) & 0xFF == ord('q'):
        break
    if int(cap.get(cv2.CAP_PROP_POS_FRAMES)) == int(cap.get(cv2.CAP_PROP_FRAME_COUNT)):
        break

writer.release()
# release the cap object
cap.release()
# close all windows
# cv2.destroyAllWindows()
# break



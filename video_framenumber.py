import cv2
import glob
import time


vidPath = r'C:\Users\emrek\Desktop\Technical\Gallaudet\videos\*\*.mp4'
newVidPath = r'C:\Users\emrek\Desktop\Technical\Gallaudet\videos2'

files = glob.glob(vidPath)
print(len(files))
fps = 30
w, h = 640, 480

for i, f in enumerate(files):
    fname = f.split('\\')[-1]
    cap = cv2.VideoCapture(f)
    fourcc = cv2.VideoWriter_fourcc('m', 'p', '4', 'v')
    writer = cv2.VideoWriter(newVidPath + '\\' + fname, fourcc, fps, (w, h))
    print(str(i+1) + '/' + str(len(files)))
    now = time.time()
    while True:

        # Capture frames in the video
        ret, frame = cap.read()

        # describe the type of font
        # to be used.
        font = cv2.FONT_HERSHEY_SIMPLEX
        # print(str(int(cap.get(cv2.CAP_PROP_POS_FRAMES))) + '/' + str(int(cap.get(cv2.CAP_PROP_FRAME_COUNT))))
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

    print('Time elapsed:' + str(time.time() - now))
    writer.release()
    # release the cap object
    cap.release()
    # close all windows
    # cv2.destroyAllWindows()
    # break

import cv2

def main():
    # Open the video capture from the file node
    cap = cv2.VideoCapture('/dev/video0')

    if not cap.isOpened():
        print("Error: Could not open video file node /dev/video0")
        return

    while True:
        # Capture frame-by-frame
        ret, frame = cap.read()

        if not ret:
            print("Error: Could not read frame from video capture")
            break

        # Display the resulting frame
        cv2.imshow('Video from /dev/video0', frame)

        # Press 'q' on the keyboard to exit the video display window
        if cv2.waitKey(1) & 0xFF == ord('q'):
            break

    # When everything done, release the video capture object
    cap.release()
    # Close all OpenCV windows
    cv2.destroyAllWindows()


main()

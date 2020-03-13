import cv2

face_cascade_fpath = 'haarcascade_frontalface_default.xml'
smile_cascade_fpath = 'haarcascade_smile.xml'
face_cascade = cv2.CascadeClassifier(face_cascade_fpath)
smile_cascade = cv2.CascadeClassifier(smile_cascade_fpath)

input_photo_dir = '/home/ec2-user/photo'
output_photo_dir = '/home/ec2-user/photo_result'

def detect_faces(input_file_path, output_file_path):
    img = cv2.imread(input_file_path)
    gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    faces = face_cascade.detectMultiScale(gray, 1.1, 5, minSize=(100,100))
    ret = 0
    for x, y, w, h in faces:
        cv2.rectangle(img, (x, y), (x + w, y + h), (0, 0, 255), 5)
        roi_gray = gray[y:y+h, x:x+w]
        roi_gray = cv2.resize(roi_gray, (100, 100))
        # 輝度で規格化
        lmin = roi_gray.min()
        lmax = roi_gray.max()
        for index1, item1 in enumerate(roi_gray):
            for index2, item2 in enumerate(item1) :
                roi_gray[index1][index2] = int((item2 - lmin)/(lmax-lmin) * item2)

        smiles = smile_cascade.detectMultiScale(roi_gray,scaleFactor=1.1, minNeighbors=0, minSize=(20, 20))#笑顔識別
        if len(smiles) > 0:
            smile_neighbors = len(smiles)
            ret = smile_neighbors
            cv2.putText(img, str(smile_neighbors), (x, y+200), cv2.FONT_HERSHEY_PLAIN, 10, (0, 0, 255), 4, cv2.LINE_AA)

    cv2.imwrite(output_file_path, img)
    return ret


if __name__ == '__main__':
    import os
    for fname in os.listdir(input_photo_dir):
        detect_faces(input_photo_dir + "/" + fname, output_photo_dir + "/" + fname)

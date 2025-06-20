import face_recognition
import sys
import os

def load_encoding(image_path):
    if not os.path.exists(image_path):
        print("error: Image file not found")
        sys.exit(1)

    image = face_recognition.load_image_file(image_path)
    encodings = face_recognition.face_encodings(image)

    if len(encodings) == 0:
        print("error: No face detected in", image_path)
        sys.exit(1)

    return encodings[0]

if len(sys.argv) != 3:
    print("error: Invalid arguments. Usage: python3 face_match.py <image1> <image2>")
    sys.exit(1)

stored_path = sys.argv[1]
uploaded_path = sys.argv[2]

stored_encoding = load_encoding(stored_path)
uploaded_encoding = load_encoding(uploaded_path)

face_distance = face_recognition.face_distance([stored_encoding], uploaded_encoding)[0]

THRESHOLD = 0.5  # Adjust as needed

if face_distance < THRESHOLD:
    print("matched")
else:
    print("not_matched")

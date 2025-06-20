import sys
import face_recognition
import os

if len(sys.argv) != 3:
    print("no match")
    sys.exit()

db_image_path = sys.argv[1]
temp_image_path = sys.argv[2]

# Check if both images exist
if not os.path.exists(db_image_path) or not os.path.exists(temp_image_path):
    print("no match")
    sys.exit()

# Load images
db_image = face_recognition.load_image_file(db_image_path)
temp_image = face_recognition.load_image_file(temp_image_path)

# Encode faces
db_encoding = face_recognition.face_encodings(db_image)
temp_encoding = face_recognition.face_encodings(temp_image)

if len(db_encoding) == 0 or len(temp_encoding) == 0:
    print("no match")
    sys.exit()

# Compare faces
match = face_recognition.compare_faces([db_encoding[0]], temp_encoding[0])

if match[0]:
    print("match")
else:
    print("no match")

import sys
import base64
import cv2
import numpy as np
import face_recognition
import json

# Decode the base64 string received from PHP
def decode_image(image_base64):
    img_data = base64.b64decode(image_base64)
    img_array = np.frombuffer(img_data, dtype=np.uint8)
    return cv2.imdecode(img_array, cv2.IMREAD_COLOR)

# Extract face embedding from the image
def extract_face_embedding(image_path):
    # Load the image
    image = face_recognition.load_image_file(image_path)

    # Find all face locations and embeddings in the image
    face_encodings = face_recognition.face_encodings(image)
    
    # If no faces are found, return None
    if len(face_encodings) == 0:
        return None
    
    # Assuming only one face is in the image, return the first face encoding
    return face_encodings[0].tolist()

def main():
    # Get the base64 image passed as a parameter
    image_base64 = sys.argv[1]

    # Decode image from base64
    image = decode_image(image_base64)
    
    # Save image temporarily for processing
    temp_image_path = 'temp_image.jpg'
    cv2.imwrite(temp_image_path, image)
    
    # Extract face embedding
    embedding = extract_face_embedding(temp_image_path)

    # If embedding is found, return it, else return error
    if embedding:
        print(json.dumps({"embedding": embedding}))  # Return as JSON
    else:
        print(json.dumps({"error": "Face not detected or embedding extraction failed"}))

if __name__ == "__main__":
    main()

import cv2
import os
import numpy as np
import mysql.connector

# Initialize face recognizer
recognizer = cv2.face.LBPHFaceRecognizer_create()

# Load face detection model
face_cascade = cv2.CascadeClassifier(cv2.data.haarcascades + 'haarcascade_frontalface_default.xml')

# Connect to MySQL database
db = mysql.connector.connect(
    host="localhost",
    user="root",  # Change to your MySQL username
    password="",  # Change to your MySQL password
    database="surevote"  # Change to your database name
)
cursor = db.cursor()

# Fetch voter images and IDs
cursor.execute("SELECT voter_id, image_path FROM voters WHERE image_path IS NOT NULL")
voters = cursor.fetchall()

faces = []
labels = []

# Process each voter image
for voter_id, image_path in voters:
    if os.path.exists(image_path):  # Check if image exists
        img = cv2.imread(image_path, cv2.IMREAD_GRAYSCALE)
        faces_detected = face_cascade.detectMultiScale(img, 1.3, 5)

        if len(faces_detected) == 0:
            print(f"No face detected for Voter ID: {voter_id}")
            continue  # Skip if no face detected

        for (x, y, w, h) in faces_detected:
            face = img[y:y + h, x:x + w]  # Extract the face region
            faces.append(face)
            labels.append(int(voter_id))  # Use voter ID as label
            print(f"Face detected and added for Voter ID: {voter_id}")

# Train the recognizer if faces were found
if len(faces) > 0:
    recognizer.train(faces, np.array(labels))
    recognizer.save("voter_faces.yml")  # Save the trained model
    print("Training completed. Model saved as 'voter_faces.yml'.")
else:
    print("No faces found for training. Check your dataset.")

# Close database connection
db.close()

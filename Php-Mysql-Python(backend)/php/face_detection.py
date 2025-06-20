from flask import Flask, request, jsonify
import cv2
from deepface import DeepFace

app = Flask(__name__)

@app.route('/detect_face', methods=['POST'])
def detect_face():
    if 'image' not in request.files:
        return jsonify({"status": "error", "message": "No image provided"}), 400

    image = request.files['image']
    image_path = 'temp_image.jpg'

    image.save(image_path)

    try:
        result = DeepFace.analyze(image_path, actions=['face_detection'])
        if len(result[0]['region']) > 0:
            return jsonify({"status": "success", "message": "Face Detected"}), 200
        else:
            return jsonify({"status": "error", "message": "No face detected"}), 400
    except Exception as e:
        return jsonify({"status": "error", "message": str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True, host='localhost', port=5000)

<?php

ini_set('display_errors', 1);
error_reporting(E_ALL);

// Database connection
$servername = "localhost";
$username   = "root";
$password   = "";
$dbname     = "surevote";

$con = new mysqli($servername, $username, $password, $dbname);

// Check database connection
if ($con->connect_error) {
    echo json_encode(["status" => "failed", "message" => "Connection failed: " . $con->connect_error]);
    exit();
}

// Set headers
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type");

// Read JSON input from Flutter
$data = json_decode(file_get_contents("php://input"), true);

// Validate received data
if (!isset($data['voter_id'], $data['position_id'], $data['candidate_id'], $data['category_id'], $data['uploaded_face'])) {
    echo json_encode(["status" => "failed", "message" => "Missing required data"]);
    exit();
}

$voter_id      = $data['voter_id'];
$position_id   = $data['position_id'];
$candidate_id  = $data['candidate_id'];
$category_id   = $data['category_id'];
$uploaded_face = $data['uploaded_face']; // Base64-encoded image from Flutter

// Check if uploaded_face is empty
if (empty($uploaded_face)) {
    echo json_encode(["status" => "failed", "message" => "Uploaded face data is empty"]);
    exit();
}

// Decode and save the uploaded image temporarily
$temp_image_path = "uploads/temp_face.jpg";
if (!file_put_contents($temp_image_path, base64_decode($uploaded_face))) {
    echo json_encode(["status" => "failed", "message" => "Failed to save uploaded face"]);
    exit();
}

// Fetch the stored face image path for the voter
$stmt = $con->prepare("SELECT image_path FROM voters WHERE voter_id = ?");
$stmt->bind_param("s", $voter_id);
$stmt->execute();
$result = $stmt->get_result();
$row = $result->fetch_assoc();

if (!$row) {
    echo json_encode(["status" => "failed", "message" => "Voter not found"]);
    exit();
}

$stored_face = $row['image_path'];  // Path of stored face image

// Check if the stored image exists
if (!file_exists($stored_face)) {
    echo json_encode(["status" => "failed", "message" => "Stored face image not found"]);
    exit();
}

// Run face verification using Python script
$match_result = shell_exec("python face_match.py $stored_face $temp_image_path");
$match_result = $match_result ? trim($match_result) : ''; // Prevent NULL issue

// Delete the temporary image after processing
unlink($temp_image_path);

if ($match_result !== "matched") {
    echo json_encode(["status" => "failed", "message" => "Face not matched. Voting denied."]);
    exit();
}

// Check if the voter has already voted for this position
$stmt = $con->prepare("SELECT id FROM votes WHERE voter_id = ? AND position_id = ?");
$stmt->bind_param("si", $voter_id, $position_id);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows > 0) {
    echo json_encode(["status" => "failed", "message" => "Voter has already voted for this position"]);
    exit();
}

// Record the vote
$stmt = $con->prepare("INSERT INTO votes (voter_id, position_id, candidate_id, category_id) VALUES (?, ?, ?, ?)");
$stmt->bind_param("siii", $voter_id, $position_id, $candidate_id, $category_id);

if ($stmt->execute()) {
    echo json_encode(["status" => "success", "message" => "Vote cast successfully"]);
} else {
    echo json_encode(["status" => "failed", "message" => "Failed to cast vote"]);
}

?>

<?php
header("Content-Type: application/json");
ini_set('display_errors', 1);
error_reporting(E_ALL);

if ($_SERVER["REQUEST_METHOD"] !== "POST") {
    echo json_encode(["status" => "error", "message" => "Invalid request method"]);
    exit();
}

if (!isset($_POST['voter_id']) || empty($_POST['voter_id'])) {
    echo json_encode(["status" => "error", "message" => "Voter ID is required"]);
    exit();
}

$voter_id = $_POST['voter_id'];
$uploaded_face = $_POST['uploaded_face']; // Base64 Image

if (empty($uploaded_face)) {
    echo json_encode(["status" => "error", "message" => "Image data is missing"]);
    exit();
}

$upload_dir = "uploads/";
if (!is_dir($upload_dir)) {
    mkdir($upload_dir, 0777, true);
}

$temp_image_path = $upload_dir . uniqid() . ".jpg";
file_put_contents($temp_image_path, base64_decode($uploaded_face));

$conn = new mysqli("localhost", "root", "", "surevote");

if ($conn->connect_error) {
    echo json_encode(["status" => "error", "message" => "Database Connection Failed"]);
    exit();
}

$stmt = $conn->prepare("SELECT image_path FROM voters WHERE voter_id = ?");
$stmt->bind_param("s", $voter_id);
$stmt->execute();
$result = $stmt->get_result();
$row = $result->fetch_assoc();

if (!$row) {
    echo json_encode(["status" => "error", "message" => "Voter not found"]);
    exit();
}

$stored_image = $row['image_path'];

$match_result = shell_exec("python face_match.py " . escapeshellarg($stored_image) . " " . escapeshellarg($temp_image_path));
error_log("Face match result: " . $match_result);
unlink($temp_image_path);

if (trim($match_result) === "matched") {
    echo json_encode(["status" => "matched", "message" => "Face verified successfully"]);
} else {
    echo json_encode(["status" => "not_matched", "message" => "Face not recognized. Try again."]);
}

?>

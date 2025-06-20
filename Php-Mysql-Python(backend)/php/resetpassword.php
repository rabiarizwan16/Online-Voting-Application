<?php
header("Content-Type: application/json");
$conn = new mysqli("localhost", "root", "", "surevote");

$data = json_decode(file_get_contents("php://input"), true);

if (!isset($data['email'], $data['token'], $data['new_password'])) {
    echo json_encode(["message" => "Missing required fields."]);
    exit;
}

$email = $conn->real_escape_string($data['email']);
$token = $conn->real_escape_string($data['token']);
$new_password = password_hash($data['new_password'], PASSWORD_DEFAULT);

// Check if token and email match
$query = "SELECT * FROM voters WHERE email='$email' AND reset_token='$token'";
$result = $conn->query($query);

if ($result->num_rows === 1) {
    // Update password
    $update = "UPDATE voters SET password='$new_password', reset_token=NULL WHERE email='$email'";
    if ($conn->query($update)) {
        echo json_encode(["message" => "Password has been reset successfully."]);
    } else {
        echo json_encode(["message" => "Failed to update password."]);
    }
} else {
    echo json_encode(["message" => "Invalid token or email."]);
}
?>

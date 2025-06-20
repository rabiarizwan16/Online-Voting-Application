<?php
header("Content-Type: application/json");

// Database connection
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "surevote";

$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    http_response_code(500);
    echo json_encode(['message' => 'Database connection failed.']);
    exit;
}

// Only allow POST requests
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405); // Method Not Allowed
    echo json_encode(['message' => 'Please use a POST request to reset your password.']);
    exit;
}

// Read and decode JSON input
$rawInput = file_get_contents('php://input');
$data = json_decode($rawInput, true);

// Handle invalid JSON
if (json_last_error() !== JSON_ERROR_NONE) {
    http_response_code(400);
    echo json_encode(['message' => 'Invalid JSON input: ' . json_last_error_msg()]);
    exit;
}

// Extract token and password
$token = $data['token'] ?? '';
$new_password = $data['new_password'] ?? '';

// Validate
if (empty($token) || empty($new_password)) {
    http_response_code(400);
    echo json_encode(['message' => 'Token and new password are required.']);
    exit;
}

// Verify token
$stmt = $conn->prepare('SELECT user_id FROM password_reset_tokens WHERE token = ? AND expiration_date > NOW()');
$stmt->bind_param('s', $token);
$stmt->execute();
$result = $stmt->get_result();
$user = $result->fetch_assoc();

if ($user) {
    $hashed_password = password_hash($new_password, PASSWORD_DEFAULT);

    // Update password
    $stmt = $conn->prepare('UPDATE voters SET password = ? WHERE id = ?');
    $stmt->bind_param('si', $hashed_password, $user['user_id']);
    $stmt->execute();

    // Delete token
    $stmt = $conn->prepare('DELETE FROM password_reset_tokens WHERE token = ?');
    $stmt->bind_param('s', $token);
    $stmt->execute();

    echo json_encode(['message' => 'Password has been reset successfully.']);
} else {
    http_response_code(400);
    echo json_encode(['message' => 'Invalid or expired token.']);
}
?>

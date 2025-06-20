<?php
header("Content-Type: application/json");

// Database configuration
$host = "localhost";
$user = "root";
$password = ""; // Replace with your MySQL password
$database = "surevote";

$conn = new mysqli($host, $user, $password, $database);

// Check connection
if ($conn->connect_error) {
    die(json_encode(["status" => "error", "message" => "Database connection failed"]));
}

// Handle POST request to add an admin
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $input = json_decode(file_get_contents('php://input'), true);

    $username = $conn->real_escape_string($input['username']);
    $password = $conn->real_escape_string($input['password']);

    // Check for empty fields
    if (empty($username) || empty($password)) {
        echo json_encode(["status" => "error", "message" => "Username and password are required"]);
        exit;
    }

    // Insert admin into the database
    $password_hashed = password_hash($password, PASSWORD_BCRYPT); // Secure password
    $query = "INSERT INTO admins (email,password) VALUES ('$username', '$password_hashed')";

    if ($conn->query($query) === TRUE) {
        echo json_encode(["status" => "success", "message" => "Admin added successfully"]);
    } else {
        echo json_encode(["status" => "error", "message" => "Error: " . $conn->error]);
    }
    $conn->close();
    exit;
}

// Default response for unsupported methods
echo json_encode(["status" => "error", "message" => "Unsupported request method"]);
?>

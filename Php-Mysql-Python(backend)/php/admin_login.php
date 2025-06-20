<?php
$servername = "localhost";
$username = "root"; // Replace with your database username
$password = ""; // Replace with your database password
$dbname = "surevote"; // Replace with your database name

// Create connection
$conn= new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
} // Include your database connection file

header('Content-Type: application/json');

// Enable full error reporting during development
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

$response = ['status' => 'error', 'message' => 'An unexpected error occurred'];

try {
    if ($_SERVER["REQUEST_METHOD"] === "POST") {
        // Get the raw POST data
        $json = file_get_contents('php://input');
        $data = json_decode($json, true);

        // Check for JSON errors
        if (json_last_error() !== JSON_ERROR_NONE) {
            throw new Exception('Invalid JSON input: ' . json_last_error_msg());
        }

        $email = $data['email'] ?? null;
        $password = $data['password'] ?? null;

        if ($email && $password) {
            // Prepare and bind
            $stmt = $conn->prepare("SELECT * FROM admins WHERE email = ?");
            if ($stmt === false) {
                throw new Exception('Statement preparation failed: ' . htmlspecialchars($conn->error));
            }

            $stmt->bind_param("s", $email);
            $stmt->execute();
            $result = $stmt->get_result();

            if ($result && $result->num_rows > 0) {
                $user = $result->fetch_assoc();
                // Log the email and password being checked
                error_log("Attempting login with email: $email and password: $password");
                // Directly compare the password
                if ($password === $user['password']) {
                    $response = ['status' => 'success', 'message' => 'Login successful'];
                } else {
                    error_log("Failed login attempt for email: $email"); // Log the failed attempt
                    $response = ['status' => 'error', 'message' => 'Invalid email or password'];
                }
            } else {
                $response = ['status' => 'error', 'message' => 'Invalid email or password'];
            }
        } else {
            $response = ['status' => 'error', 'message' => 'Email and password are required'];
        }
    } else {
        $response = ['status' => 'error', 'message' => 'Invalid request method'];
    }
} catch (Exception $e) {
    $response = ['status' => 'error', 'message' => $e->getMessage()];
} finally {
    echo json_encode($response);
    exit; // Ensure no additional output is sent
}
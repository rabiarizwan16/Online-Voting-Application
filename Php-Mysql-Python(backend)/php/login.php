<?php 
// Enable error reporting for development
ini_set('display_errors', 1);
error_reporting(E_ALL);

// Database connection
$host = "localhost";
$user = "root";
$password = "";
$dbname = "surevote";

$conn = new mysqli($host, $user, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Function to handle login
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    // Get the JSON data from the request
    $json = file_get_contents('php://input');
    $data = json_decode($json, true);

    // Sanitize input
    $phone = filter_var($data['phone'], FILTER_SANITIZE_NUMBER_INT);
    $password = $data['password'];

    if (empty($phone) || empty($password)) {
        echo json_encode(['error' => 'Phone and password are required']);
        exit();
    }

    // Check if user exists in the database
    $stmt = $conn->prepare("SELECT * FROM voters WHERE phone = ?");
    $stmt->bind_param("s", $phone);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows > 0) {
        // User found, verify the password
        $user = $result->fetch_assoc();
        if (password_verify($password, $user['password'])) {
            // Password is correct
            echo json_encode(['status' => 'success', 'message' => 'Login successful']);
        } else {
            // Incorrect password
            echo json_encode(['error' => 'wrong_password', 'message' => 'Incorrect password']);
        }
    } else {
        // No user found
        echo json_encode(['error' => 'user_not_found', 'message' => 'User not found']);
    }

    $stmt->close();
}

$conn->close();
?>


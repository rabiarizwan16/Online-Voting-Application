<?php
$servername = "localhost";
$username = "root"; // Replace with your database username
$password = ""; // Replace with your database password
$dbname = "surevote"; // Replace with your database name

// Create connection
$con= new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($con->connect_error) {
    die(json_encode(['status' => 'error', 'error' => 'Database connection failed']));
}


$userId = $_GET['user_id']; // Get user ID from request

$query = "SELECT name, email FROM voters WHERE id = '$userId'";
$result = mysqli_query($con, $query);

if ($row = mysqli_fetch_assoc($result)) {
    echo json_encode([
        'status' => 'success',
        'name' => $row['name'],
        'email' => $row['email']
    ]);
} else {
    echo json_encode(['status' => 'error', 'message' => 'User not found']);
}

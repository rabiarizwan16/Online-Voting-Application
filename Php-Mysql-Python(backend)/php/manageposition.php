<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);


header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type");
header("Access-Control-Allow-Methods: POST");
header('Content-Type: application/json');


if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    echo json_encode(["status" => "error", "message" => "Invalid request method"]);
    exit();
}

// Debugging: Save received POST & FILES data to a log file
file_put_contents("debug_log.txt", "POST Data:\n" . print_r($_POST, true) . "\nFILES Data:\n" . print_r($_FILES, true));

// Database connection
$host = "localhost"; // Change as per your setup
$username = "root";  // Change as per your setup
$password = "";      // Change as per your setup
$dbname = "surevote"; // Use your database name
$con = new mysqli($host, $username, $password, $dbname);

// Check database connection
if ($con->connect_error) {
    echo json_encode(['status' => 'error', 'message' => 'Database connection failed: ' . $con->connect_error]);
    exit();
}

// Validate all required fields
if (!isset($_POST['position_name'], $_POST['category'], $_POST['candidate_name'], $_POST['party_name'], $_FILES['candidate_symbol_image'])) {
    echo json_encode(['status' => 'error', 'message' => 'All fields and image are required!']);
    exit();
}

$position_name = $con->real_escape_string($_POST['position_name']);
$category = $con->real_escape_string($_POST['category']);
$candidate_name = $con->real_escape_string($_POST['candidate_name']);
$party_name = $con->real_escape_string($_POST['party_name']);

// Handle the image upload
$symbol_image = $_FILES['candidate_symbol_image'];
$upload_dir = 'uploads/'; // Directory to store images

// Ensure upload directory exists
if (!is_dir($upload_dir)) {
    mkdir($upload_dir, 0777, true);
}

$image_path = $upload_dir . basename($symbol_image['name']);

if (!move_uploaded_file($symbol_image['tmp_name'], $image_path)) {
    echo json_encode(['status' => 'error', 'message' => 'Error uploading image.']);
    exit();
}

// Check or insert category
$category_id = null;
$category_check_query = "SELECT category_id FROM categories WHERE category_name = '$category'";
$category_check_result = $con->query($category_check_query);

if ($category_check_result && $category_check_result->num_rows > 0) {
    $category_row = $category_check_result->fetch_assoc();
    $category_id = $category_row['category_id'];
} else {
    $category_insert_query = "INSERT INTO categories (category_name) VALUES ('$category')";
    if ($con->query($category_insert_query)) {
        $category_id = $con->insert_id;
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Error inserting category: ' . $con->error]);
        exit();
    }
}

// Check or insert position
$position_id = null;
$position_check_query = "SELECT id FROM positions WHERE position_name = '$position_name' AND category_id = $category_id";
$position_check_result = $con->query($position_check_query);

if ($position_check_result && $position_check_result->num_rows > 0) {
    $position_row = $position_check_result->fetch_assoc();
    $position_id = $position_row['id'];
} else {
    $position_insert_query = "INSERT INTO positions (position_name, category_id) VALUES ('$position_name', $category_id)";
    if ($con->query($position_insert_query)) {
        $position_id = $con->insert_id;
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Error inserting position: ' . $con->error]);
        exit();
    }
}

// Insert candidate
$candidate_insert_query = "INSERT INTO candidates (candidate_name, party_name, candidate_symbol_image_path, position_id) 
                            VALUES ('$candidate_name', '$party_name', '$image_path', $position_id)";

if ($con->query($candidate_insert_query)) {
    echo json_encode(['status' => 'success', 'message' => 'Position and candidate added successfully!']);
} else {
    echo json_encode(['status' => 'error', 'message' => 'Error inserting candidate: ' . $con->error]);
}

// Close database connection
$con->close();
?>

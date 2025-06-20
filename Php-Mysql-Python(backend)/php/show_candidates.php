<?php
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "surevote";

$con = new mysqli($servername, $username, $password, $dbname);

if ($con->connect_error) {
    die("Connection failed: " . $con->connect_error);
}

$position_id = isset($_GET['position_id']) ? intval($_GET['position_id']) : 0;

if ($position_id > 0) {
    $query = "SELECT * FROM candidates WHERE position_id = ?";
    $stmt = $con->prepare($query);
    $stmt->bind_param("i", $position_id);
} else {
    $query = "SELECT * FROM candidates";
    $stmt = $con->prepare($query);
}

$stmt->execute();
$result = $stmt->get_result();

$candidates = [];

while ($row = $result->fetch_assoc()) {
    $candidates[] = $row;
}

echo json_encode($candidates);
?>

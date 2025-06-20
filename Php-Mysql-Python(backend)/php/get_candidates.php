<?php
$servername = "localhost";
$username = "root"; 
$password = ""; 
$dbname = "surevote"; 

$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
} 

$position_id = $_GET['position_id'] ?? '';

$sql = "SELECT id, candidate_name, candidate_symbol_image_path, party_name 
        FROM candidates WHERE position_id = ?";
$stmt = $conn->prepare($sql);
$stmt->bind_param("i", $position_id);
$stmt->execute();
$result = $stmt->get_result();

$candidates = [];
while ($row = $result->fetch_assoc()) {
    $candidates[] = [
        'id' => $row['id'],
        'name' => $row['candidate_name'],
        'symbol_image' => $row['candidate_symbol_image_path'],
        'party' => $row['party_name']
    ];
}

header('Content-Type: application/json');
echo json_encode($candidates);
?>

<?php 
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "surevote";

$con = new mysqli($servername, $username, $password, $dbname);

if ($con->connect_error) {
    die("Connection failed: " . $con->connect_error);
}

// If category ID is provided, filter positions by category
if (isset($_GET['category']) && !empty($_GET['category'])) {
    $category_id = $_GET['category'];
    $query = "SELECT id, position_name FROM positions WHERE category_id = ?";
    $stmt = $con->prepare($query);
    $stmt->bind_param("i", $category_id);
} else {
    // If no category is provided, fetch all positions
    $query = "SELECT id, position_name FROM positions";
    $stmt = $con->prepare($query);
}

$stmt->execute();
$result = $stmt->get_result();

$positions = [];
while ($row = mysqli_fetch_assoc($result)) {
    $positions[] = [
        "id" => strval($row["id"]), // Convert to string
        "name" => $row["position_name"]
    ];
}


// Return JSON response
echo json_encode($positions);
?>

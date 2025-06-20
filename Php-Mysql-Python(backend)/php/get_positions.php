<?php 
$servername = "localhost";
$username = "root"; // Replace with your database username
$password = ""; // Replace with your database password
$dbname = "surevote"; // Replace with your database name

// Create connection
$con = new mysqli($servername, $username, $password, $dbname);

// Check connection
if (isset($_GET['category'])) {
    $category_id = $_GET['category']; // Category ID passed as a GET parameter.

    $query = "SELECT id, position_name FROM positions WHERE category_id = ?";
    $stmt = $con->prepare($query);
    $stmt->bind_param("i", $category_id);
    $stmt->execute();
    $result = $stmt->get_result();

    $positions = [];
    while ($row = $result->fetch_assoc()) {
        $positions[] = $row; // Add each position to the array.
    }

    echo json_encode($positions); // Return JSON-encoded positions array.
} else {
    echo json_encode(["error" => "Category ID not provided"]);
}
?>
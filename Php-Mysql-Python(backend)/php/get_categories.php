<?php
$servername = "localhost";
$username = "root"; 
$password = ""; 
$dbname = "surevote"; 

$con = new mysqli($servername, $username, $password, $dbname);

if ($con->connect_error) {
    die("Connection failed: " . $con->connect_error);
} 


$query = "SELECT category_id, category_name FROM categories";
$result = mysqli_query($con, $query);

$categories = [];

while ($row = mysqli_fetch_assoc($result)) {
    $categories[] = $row;
}

echo json_encode($categories);
?>

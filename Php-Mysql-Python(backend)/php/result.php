<?php
$servername = "localhost";
$username   = "root";
$password   = "";
$dbname     = "surevote";

$con = new mysqli($servername, $username, $password, $dbname);
if ($con->connect_error) {
    die("Connection failed: " . $con->connect_error);
}

$query = "SELECT 
            c.name AS category_name, 
            p.name AS position_name, 
            cand.name AS candidate_name,
            COUNT(v.id) AS vote_count
          FROM votes v
          JOIN categories c ON v.category_id = c.id
          JOIN positions p ON v.position_id = p.id
          JOIN candidates cand ON v.candidate_id = cand.id
          GROUP BY v.category_id, v.position_id, v.candidate_id
          ORDER BY c.name, p.name, vote_count DESC";

$result = mysqli_query($con, $query);
$resultsArray = [];

if ($result) {
    while($row = mysqli_fetch_assoc($result)) {
        $resultsArray[] = $row;
    }
    echo json_encode(["status" => "success", "data" => $resultsArray]);
} else {
    echo json_encode(["status" => "failed", "message" => mysqli_error($con)]);
}
?>

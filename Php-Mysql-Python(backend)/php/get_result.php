<?php
header("Content-Type: application/json");
$conn = new mysqli("localhost", "root", "", "surevote");

if ($conn->connect_error) {
    die(json_encode(["error" => "Database connection failed"]));
}

$query = "SELECT 
    cat.category_name, 
    pos.position_name, 
    can.candidate_name, 
    SUM(vr.votes) AS votes  
FROM candidates can
JOIN positions pos ON can.position_id = pos.id  -- ✅ Fixed position join
JOIN categories cat ON pos.category_id = cat.category_id  -- ✅ Matches schema
JOIN voting_results vr ON can.id = vr.candidate_id
GROUP BY cat.category_name, pos.position_name, can.candidate_name
ORDER BY cat.category_name, pos.position_name, votes DESC";


$result = $conn->query($query);

$data = [];
while ($row = $result->fetch_assoc()) {
    $category = $row["category_name"];
    $position = $row["position_name"];
    $candidate = ["candidate_name" => $row["candidate_name"], "votes" => $row["votes"]];

    $found = false;
    foreach ($data as &$entry) {
        if ($entry["category"] == $category && $entry["position"] == $position) {
            $entry["candidates"][] = $candidate;
            $found = true;
            break;
        }
    }
    if (!$found) {
        $data[] = ["category" => $category, "position" => $position, "candidates" => [$candidate]];
    }
}

echo json_encode($data);
$conn->close();


?>

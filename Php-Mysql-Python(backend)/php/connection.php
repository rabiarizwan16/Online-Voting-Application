<?php
use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;

// Include PHPMailer classes
require 'PHPMailer/src/Exception.php';
require 'PHPMailer/src/PHPMailer.php';
require 'PHPMailer/src/SMTP.php';

error_reporting(0);
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

$host = "localhost";
$username = "root";
$password = "";
$database = "surevote";

$conn = new mysqli($host, $username, $password, $database);
if ($conn->connect_error) {
    echo json_encode(["error" => "Database connection failed"]);
    exit;
}

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $name = $_POST['name'];
    $email = $_POST['email'];
    $password = $_POST['password'];
    $phone = $_POST['phone'];
    $aadhaar = $_POST['aadhaar'];
    $voter_id = $_POST['voter_id'];
    $dob = $_POST['dob'];
    $gender = $_POST['gender'];

    $target_dir = "uploads/";
    $image_path = "";

    if (empty($_FILES) || !isset($_FILES['profile_picture'])) {
        echo json_encode(["error" => "Profile picture is required"]);
        exit;
    }

    if ($_FILES['profile_picture']['error'] == 0) {
        $image_name = uniqid() . "." . pathinfo($_FILES["profile_picture"]["name"], PATHINFO_EXTENSION);
        $target_file = $target_dir . $image_name;

        if (move_uploaded_file($_FILES["profile_picture"]["tmp_name"], $target_file)) {
            $image_path = $target_file;
        } else {
            echo json_encode(["error" => "Failed to upload profile picture"]);
            exit;
        }
    }

    $check = function ($field, $value) use ($conn) {
        $stmt = $conn->prepare("SELECT * FROM voters WHERE $field = ?");
        $stmt->bind_param("s", $value);
        $stmt->execute();
        return $stmt->get_result()->num_rows > 0;
    };

    if ($check('email', $email)) {
        echo json_encode(["email_error" => "This email already exists"]);
        exit;
    }

    if ($check('aadhaar', $aadhaar)) {
        echo json_encode(["aadhaar_error" => "This Aadhaar number already exists"]);
        exit;
    }

    if ($check('voter_id', $voter_id)) {
        echo json_encode(["voter_id_error" => "This Voter ID already exists"]);
        exit;
    }

    $stmt = $conn->prepare("INSERT INTO voters (name, email, password, phone, aadhaar, voter_id, dob, image_path) VALUES (?, ?, ?, ?, ?, ?, ?, ?)");
    $hashed_password = password_hash($password, PASSWORD_BCRYPT);
    $stmt->bind_param("ssssssss", $name, $email, $hashed_password, $phone, $aadhaar, $voter_id, $dob, $image_path);

    if ($stmt->execute()) {
        // Send registration confirmation email
        $mail = new PHPMailer(true);

        try {
            $mail->isSMTP();
            $mail->Host = 'smtp.gmail.com';
            $mail->SMTPAuth = true;
            $mail->Username = 'yourgmail@gmail.com'; // Your Gmail
            $mail->Password = 'your-app-password';   // App password
            $mail->SMTPSecure = 'tls';
            $mail->Port = 587;

            $mail->setFrom('yourgmail@gmail.com', 'SureVote');
            $mail->addAddress($email, $name);
            $mail->Subject = 'SureVote Registration Successful';
            $mail->Body = "Hello $name,\n\nYou have successfully registered on SureVote.\nYour Voter ID: $voter_id\n\nThank you for being a responsible citizen!";

            $mail->send();
        } catch (Exception $e) {
            error_log("Email sending failed: " . $mail->ErrorInfo);
        }

        echo json_encode(["success" => "Registration successful"]);
    } else {
        echo json_encode(["error" => "Failed to register"]);
    }

    $stmt->close();
    $conn->close();
} else {
    echo json_encode(["error" => "Invalid request"]);
}
?>

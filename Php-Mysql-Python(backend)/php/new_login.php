<?php
use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;

// Include PHPMailer classes
require 'PHPMailer/src/Exception.php';
require 'PHPMailer/src/PHPMailer.php';
require 'PHPMailer/src/SMTP.php';

$servername = "localhost";
$username = "root";
$password = "";
$dbname = "surevote";

$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die(json_encode(['status' => 'error', 'error' => 'Database connection failed']));
}

header("Content-Type: application/json");
$data = json_decode(file_get_contents("php://input"));

if (isset($data->phone) && isset($data->password)) {
    $phone = $data->phone;
    $password = $data->password;

    $stmt = $conn->prepare("SELECT id, name, email, password FROM voters WHERE phone = ?");
    $stmt->bind_param("s", $phone);
    $stmt->execute();
    $result = $stmt->get_result();

    if ($result->num_rows > 0) {
        $user = $result->fetch_assoc();

        if (password_verify($password, $user['password'])) {
            unset($user['password']);

            // Send email via PHPMailer
            $mail = new PHPMailer(true);

            try {
                // SMTP settings
                $mail->isSMTP();
                $mail->Host = 'smtp.gmail.com';
                $mail->SMTPAuth = true;
                $mail->Username = 'therabia412@gmail.com'; // Your Gmail address
                $mail->Password = 'fqcc timr iufw gohd'; // Gmail App Password
                $mail->SMTPSecure = 'tls';
                $mail->Port = 587;

                // Email content
                $mail->setFrom('yourgmail@gmail.com', 'SureVote');
                $mail->addAddress($user['email'], $user['name']);
                $mail->Subject = 'SureVote Login Notification';
                $mail->Body = "Hello " . $user['name'] . ",\n\nYou have successfully logged into SureVote on " . date("Y-m-d H:i:s") . ".\n\nIf this wasn't you, please contact support immediately.";

                $mail->send();
            } catch (Exception $e) {
                error_log("Email error: " . $mail->ErrorInfo);
            }

            echo json_encode([
                'status' => 'success',
                'user' => [
                    'id' => $user['id'],
                    'name' => $user['name'],
                    'email' => $user['email'],
                    'phone' => $phone
                ]
            ]);
        } else {
            echo json_encode(['status' => 'error', 'error' => 'wrong_password']);
        }
    } else {
        echo json_encode(['status' => 'error', 'error' => 'user_not_found']);
    }

    $stmt->close();
} else {
    echo json_encode(['status' => 'error', 'error' => 'invalid_request']);
}

$conn->close();
?>

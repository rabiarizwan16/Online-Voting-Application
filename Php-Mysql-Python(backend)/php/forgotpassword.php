<?php
$servername = "localhost";
$username = "root"; // Replace with your database username
$password = ""; // Replace with your database password
$dbname = "surevote"; // Replace with your database name

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die(json_encode(['message' => 'Connection failed: ' . $conn->connect_error]));
}

// Include PHPMailer classes
require 'PHPMailer/src/Exception.php';
require 'PHPMailer/src/PHPMailer.php';
require 'PHPMailer/src/SMTP.php';

use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;

// Get the POST data
$data = json_decode(file_get_contents('php://input'), true);
$email = $data['email'] ?? '';

if (filter_var($email, FILTER_VALIDATE_EMAIL)) {
    // Check if the email exists in the database
    $stmt = $conn->prepare('SELECT id FROM voters WHERE email = ?');
    $stmt->bind_param('s', $email);
    $stmt->execute();
    $result = $stmt->get_result();
    $user = $result->fetch_assoc();

    if ($user) {
        // Generate a secure token
        $token = bin2hex(random_bytes(16));
        $expires = date('Y-m-d H:i:s', strtotime('+1 hour'));
        $status = 'active';


        //    // Invalidate previous tokens (optional but good practice)
        //    $conn->prepare('UPDATE password_reset_tokens SET status = "expired" WHERE user_id = ? AND status = "active"')
        //    ->bind_param('i', $user['id'])
        //    ->execute();


        // Store the token in the database
        $stmt = $conn->prepare('INSERT INTO password_reset_tokens (user_id, token, expiration_date) VALUES (?, ?, ?)');
        $stmt->bind_param('iss', $user['id'], $token, $expires);
        $stmt->execute();

        // Send the reset link via email using PHPMailer
        $resetLink = "http://192.168.195.33/php/resetpassword.php?token=$token";
        $subject = 'Password Reset Request';
        $message = "<p>Click the following link to reset your password:</p>
    <p><a href='$resetLink'>$resetLink</a></p>
    <p>If you did not request a password reset, please ignore this email.</p>";
        
        
        $mail = new PHPMailer(true);
        try {
            // Server settings
            $mail->isSMTP();
            $mail->Host = 'smtp.gmail.com';
            $mail->SMTPAuth = true;
            $mail->Username = 'therabia412@gmail.com'; // Your Gmail address
            $mail->Password = 'fqcc timr iufw gohd'; // Your Gmail password or App Password
            $mail->SMTPSecure = PHPMailer::ENCRYPTION_STARTTLS;
$mail->Port = 587;

            // Recipients
            $mail->setFrom('therabia412@gmail.com', 'SureVote');
            $mail->addAddress($email);

            // Content
            $mail->isHTML(true);
            $mail->Subject = $subject;
            $mail->Body    = $message;

            $mail->send();
            echo json_encode(['message' => 'Password reset link has been sent to your email.']);
        } catch (Exception $e) {
            echo json_encode(['message' => 'Failed to send email. Mailer Error: ' . $mail->ErrorInfo]);
        }
    } else {
        echo json_encode(['message' => 'Email not found.']);
    }
} else {
    echo json_encode(['message' => 'Invalid email address.']);
}
?>

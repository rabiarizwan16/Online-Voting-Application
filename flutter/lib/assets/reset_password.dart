import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ResetPasswordPage extends StatefulWidget {
  final String token;

  ResetPasswordPage({required this.token});

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController _newPasswordController = TextEditingController();
  bool _isSubmitting = false;
  String _errorMessage = '';

  // Function to validate the new password
  bool _validatePassword(String password) {
    return password.length >= 6; // Basic validation
  }

  Future<void> _resetPassword() async {
    if (_newPasswordController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter a new password';
      });
      return;
    }

    if (!_validatePassword(_newPasswordController.text)) {
      setState(() {
        _errorMessage = 'Password must be at least 6 characters';
      });
      return;
    }

    setState(() {
      _isSubmitting = true;
      _errorMessage = ''; // Reset error message
    });

    try {
      // Log the token and new password
      print("Token: ${widget.token}");
      print("New Password: ${_newPasswordController.text}");

      final response = await http.post(
        Uri.parse('http://192.168.0.107/php/resetpassword.php'),
        body: {
          'token': widget.token,
          'new_password': _newPasswordController.text,
        },
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 && responseData['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Your password has been reset successfully')),
        );
        // Navigate to the login page or wherever you want
        // Navigator.pushReplacement(context, MaterialPageRoute (builder: (context) => LoginPage()));
      } else {
        setState(() {
          _errorMessage = responseData['message'] ?? 'An unknown error occurred';
        });
      }
    } catch (error) {
      setState(() {
        _errorMessage = 'Failed to reset password. Please try again later.';
      });
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reset Password')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _newPasswordController,
              decoration: InputDecoration(
                labelText: 'New Password',
                errorText: _errorMessage.isNotEmpty ? _errorMessage : null,
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isSubmitting ? null : _resetPassword,
              child: _isSubmitting ? CircularProgressIndicator() : Text('Reset Password'),
            ),
          ],
        ),
      ),
    );
  }
}
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:surevote/forget_password.dart';
import 'package:surevote/registration_page.dart';
import 'package:surevote/vote_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isSubmitting = false;

  // Login function
  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });

      try {
        final body = jsonEncode({
          'phone': _phoneController.text,
          'password': _passwordController.text,
        });

        // API call to login
        final response = await http.post(
          Uri.parse('http://192.168.195.33/php/login.php'), // Use actual IP if on physical device
          headers: {'Content-Type': 'application/json'},
          body: body,
        );

        // Debugging: Check the response
        print("Response Status: ${response.statusCode}");
        print("Response Body: ${response.body}");

        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);

          // Check for successful login response
          if (responseData['status'] == 'success') {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Login Successful')),
            );
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => VotePage()),
            );
          } else if (responseData['error'] == 'user_not_found') {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('User not found')),
            );
          } else if (responseData['error'] == 'wrong_password') {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Incorrect password')),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('An unknown error occurred')),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Login failed, please try again')),
          );
        }
      } catch (e) {
        print("Error occurred: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error occurred, please try again later')),
        );
      } finally {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE6F7FF),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Color(0xFFE6F7FF)),
        title: Text(
          'Login for Voting',
          style: TextStyle(color: Color(0xFFE6F7FF)),
        ),
        backgroundColor: Color(0xFF00165a),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Logo Image
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Image.asset('assets/images/logo.png', height: 100),
            ),
            SizedBox(height: 20),

            // Text to indicate the login page
            Text(
              'Election Commission of India',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),

            // Text to guide the user
            Text(
              'If you are a registered user, enter your mobile number to login',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            SizedBox(height: 20),

            // Form to enter login details
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(labelText: 'Phone Number'),
                    keyboardType: TextInputType.phone,
                    validator: (value) => value == null || value.length != 10
                        ? 'Enter a valid 10-digit phone number'
                        : null,
                  ),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    validator: (value) => value == null || value.length < 6
                        ? 'Password must be at least 6 characters'
                        : null,
                  ),
                  SizedBox(height: 10),
                  // Forget Password Link
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ForgotPasswordPage()),
                        );
                      },
                      child: Text('Forget Password'),
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: 200,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                        _isSubmitting ? Colors.grey : Color(0xFF00165a),
                      ),
                      child: _isSubmitting
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text('Login'),
                    ),
                  ),

                  SizedBox(height: 10),
                  // New User Button (for registration)
                  SizedBox(
                    width: 200,
                    height: 40,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegistrationPage()),
                        );
                      },
                      child: Text('New User'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

    );
  }
}

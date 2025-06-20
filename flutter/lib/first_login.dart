import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:surevote/forget_password.dart';
import 'package:surevote/initial_page.dart';
import 'package:surevote/registration_page.dart';

class NewLoginPage extends StatefulWidget {
  @override
  _NewLoginPageState createState() => _NewLoginPageState();
}

class _NewLoginPageState extends State<NewLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isSubmitting = false;

  // Function to save user data locally
  Future<void> _saveUserDetails(Map<String, dynamic> userData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('phone', userData['phone']);
    await prefs.setString('name', userData['name']);
    await prefs.setString('email', userData['email']);
  }

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

        final response = await http.post(
          Uri.parse('http://192.168.195.33/php/new_login.php'),
          headers: {'Content-Type': 'application/json'},
          body: body,
        );

        print("Response Status: ${response.statusCode}");
        print("Response Body: ${response.body}");

        if (response.statusCode == 200) {
          final responseData = jsonDecode(response.body);

          if (responseData['status'] == 'success') {
            // Fetch user details from response
            final userData = responseData['user'];

            // Save user details locally
            await _saveUserDetails(userData);

            // ScaffoldMessenger.of(context).showSnackBar(
            //   SnackBar(content: Text('Login Successful')),
            // );

            // Navigate to InitialPage after saving user data
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => InitialPage()),
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
          'Login',
          style: TextStyle(color: Color(0xFFE6F7FF)),
        ),
        backgroundColor: Color(0xFF00165a),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: Image.asset('assets/images/logo.png', height: 100),
            ),
            SizedBox(height: 20),

            Text(
              'Election Commission of India',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),

            Text(
              'If you are a registered user, enter your mobile number to login',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            SizedBox(height: 20),

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

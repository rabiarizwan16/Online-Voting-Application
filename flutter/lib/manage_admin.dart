import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ManageAdminPage extends StatefulWidget {
  const ManageAdminPage({Key? key}) : super(key: key);

  @override
  _ManageAdminPageState createState() => _ManageAdminPageState();
}

class _ManageAdminPageState extends State<ManageAdminPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _message = '';

  Future<void> addAdmin() async {
    const String url = 'http://192.168.195.33/php/manageadmin.php';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': _usernameController.text,
          'password': _passwordController.text,
        }),
      );

      final responseData = jsonDecode(response.body);
      setState(() {
        _message = responseData['message'];
      });

      if (responseData['status'] == 'success') {
        _usernameController.clear();
        _passwordController.clear();
      }
    } catch (error) {
      setState(() {
        _message = 'Error adding admin: $error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text('Manage Admins',style: TextStyle(color: Colors.white),), backgroundColor: Color(0xFF00165a),),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(

              onPressed: addAdmin,
              child: const Text('Add Admin',style: TextStyle(color: Colors.white),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF00165a),)
            ),
            const SizedBox(height: 20),
            if (_message.isNotEmpty)
              Text(
                _message,
                style: TextStyle(
                  color: _message.contains('success') ? Colors.green : Colors.red,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

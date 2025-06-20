import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:surevote/initial_page.dart';


class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _aadhaarController = TextEditingController();
  final TextEditingController _voterIdController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  File? _image;
  bool _isSubmitting = false;

  String? _selectedGender;
  String? _ageError;
  // Error message variables
  String? emailError;
  String? aadhaarError;
  String? voterIdError;
  String? passwordError;

  // Pick date of birth
  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dobController.text = DateFormat('yyyy-MM-dd').format(picked);
        int age = DateTime.now().year - picked.year;
        _ageError = age < 18 ? 'You cannot register as your age is below 18.' : null;
      });
    }
  }







  // Pick image from gallery

  final picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
      print("Image Selected: ${_image!.path}");
    } else {
      print("No Image Selected");
    }
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
        emailError = null;
        aadhaarError = null;
        voterIdError = null;
        passwordError = null;
      });

      if (_image == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile picture is required'), backgroundColor: Colors.red),
        );
        setState(() {
          _isSubmitting = false;
        });
        return;
      }

      try {
        var uri = Uri.parse('http://192.168.195.33/php/connection.php');
        var request = http.MultipartRequest('POST', uri);

        // Attach form fields
        request.fields['name'] = _nameController.text;
        request.fields['email'] = _emailController.text;
        request.fields['password'] = _passwordController.text;
        request.fields['phone'] = _phoneController.text;
        request.fields['aadhaar'] = _aadhaarController.text;
        request.fields['voter_id'] = _voterIdController.text;
        request.fields['dob'] = _dobController.text;
        request.fields['gender'] = _selectedGender ?? '';

        // Attach image file
        request.files.add(
          await http.MultipartFile.fromPath('profile_picture', _image!.path),
        );

        // Send request
        var response = await request.send();
        var responseBody = await response.stream.bytesToString();
        var responseData = jsonDecode(responseBody);

        print("Response Code: ${response.statusCode}");
        print("Response Body: $responseBody");

        setState(() {
          emailError = responseData['email_error'];
          aadhaarError = responseData['aadhaar_error'];
          voterIdError = responseData['voter_id_error'];
          passwordError = responseData['password_error'];
        });

        if (emailError != null || aadhaarError != null || voterIdError != null || passwordError != null) {
          return;
        }

        if (responseData.containsKey('success')) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Registered successfully!'), backgroundColor: Colors.green),
          );

          Future.delayed(Duration(seconds: 2), () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => InitialPage()),
            );
          });
        } else if (responseData.containsKey('error')) {
          setState(() {
            emailError = responseData['error'];
          });
        }
      } catch (e) {
        print("Flutter Error: $e");
        setState(() {
          emailError = "Error: ${e.toString()}";
        });
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
        title: Text('Register',style: TextStyle(color: Color(0xFFE6F7FF)),),
        backgroundColor: Color(0xFF00165a),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.0), // Optional spacing from the right
            child: Image.asset(
              'assets/images/logo.png', // Replace with your image asset
              height: 40, // Adjust height as needed
              width: 40, // Adjust width as needed
              fit: BoxFit.contain, // Ensures proper scaling
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Centered top image
              Image.asset(
                'assets/images/Voter-Registration_new.png',
                height: 180,
                width: 200,
              ),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Full Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter your name';
                  } else if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(value)) {
                    return 'Only alphabets are allowed';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  errorText: emailError, // Show error message below email field
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value == null || !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)
                    ? 'Enter a valid email'
                    : null,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password',
                  errorText: passwordError,),
                obscureText: true,
                validator: (value) => value == null || value.length < 6
                    ? 'Password must be at least 6 characters'
                    : null,
              ),
              DropdownButtonFormField<String>(
                value: _selectedGender,
                decoration: InputDecoration(labelText: 'Gender'),
                items: ['Male', 'Female', 'Other'].map((gender) {
                  return DropdownMenuItem(
                    value: gender,
                    child: Text(gender),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value;
                  });
                },
                validator: (value) => value == null ? 'Please select a gender' : null,
              ),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
                validator: (value) => value == null || !RegExp(r'^\d{10}$').hasMatch(value)
                    ? 'Enter a valid 10-digit phone number'
                    : null,
              ),
              TextFormField(
                controller: _aadhaarController,
                decoration: InputDecoration(
                  labelText: "Aadhaar Number",
                  errorText: aadhaarError, // Show error message below Aadhaar field
                ),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || !RegExp(r'^\d{12}$').hasMatch(value)
                    ? 'Enter a valid Aadhaar number'
                    : null,
              ),
              TextFormField(
                controller: _voterIdController,
                decoration:InputDecoration(
                  labelText: "Voter ID",
                  errorText: voterIdError, // Show error message below Voter ID field
                ),
                validator: (value) => value == null || !RegExp(r'^[A-Z]{3}[0-9]{7}$').hasMatch(value)
                    ? 'Enter a valid Voter ID'
                    : null,
              ),
            TextFormField(
              controller: _dobController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Date of Birth',
                suffixIcon: Icon(Icons.calendar_today),
                errorText: _ageError, // Show age error below the field
              ),
              onTap: () => _selectDate(context),
              validator: (value) => _ageError, // Ensure the form fails validation if age is below 18
            ),
              SizedBox(height: 12),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _image == null
                      ? Icon(Icons.add_a_photo, size: 40, color: Colors.grey)
                      : Image.file(_image!, fit: BoxFit.cover),
                ),
              ),
              Text(
                'Please ensure that your picture must be updated annually to maintain active registration status.',
                style: TextStyle(fontSize: 16, color: Colors.blue),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _register,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isSubmitting ? Colors.grey : Color(0xFF00165a),
                ),
                child: _isSubmitting
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text('Register',style: TextStyle(color:Color(0xFFE6F7FF)),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

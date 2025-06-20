import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class ManagePositionsPage extends StatefulWidget {
  const ManagePositionsPage({Key? key}) : super(key: key);

  @override
  _ManagePositionsPageState createState() => _ManagePositionsPageState();
}

class _ManagePositionsPageState extends State<ManagePositionsPage> {
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _positionController = TextEditingController();
  final TextEditingController _candidateController = TextEditingController();
  final TextEditingController _partyController = TextEditingController();

  File? _symbolImage;
  String _message = '';
  bool _isLoading = false;

  final String _apiUrl = "http://192.168.195.33/php/manageposition.php"; // Ensure correct endpoint

  Future<void> savePosition() async {
    String category = _categoryController.text.trim();
    String position = _positionController.text.trim();
    String candidate = _candidateController.text.trim();
    String party = _partyController.text.trim();

    if (category.isEmpty || position.isEmpty || candidate.isEmpty || party.isEmpty || _symbolImage == null) {
      setState(() {
        _message = "All fields, including an image, are required!";
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _message = '';
    });

    try {
      var request = http.MultipartRequest("POST", Uri.parse(_apiUrl));
      request.fields['category'] = category;
      request.fields['position_name'] = position;
      request.fields['candidate_name'] = candidate;
      request.fields['party_name'] = party;

      // Detect the MIME type dynamically
      String? mimeType = lookupMimeType(_symbolImage!.path);
      var contentType = mimeType != null ? MediaType.parse(mimeType) : MediaType('image', 'jpeg');

      request.files.add(await http.MultipartFile.fromPath(
        'candidate_symbol_image',
        _symbolImage!.path,
        contentType: contentType,
      ));

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      // Debug: Print API Response
      print("API Response: $responseBody");

      if (response.statusCode == 200) {
        try {
          final data = jsonDecode(responseBody);
          setState(() {
            _message = data['message'];
          });

          if (data['status'] == 'success') {
            _categoryController.clear();
            _positionController.clear();
            _candidateController.clear();
            _partyController.clear();
            setState(() {
              _symbolImage = null;
            });
          }
        } catch (e) {
          print("JSON Parse Error: $e");
          setState(() {
            _message = "Invalid server response format";
          });
        }
      } else {
        setState(() {
          _message = "Server error: ${response.statusCode}";
        });
      }
    } catch (error) {
      print("Error: $error");
      setState(() {
        _message = "Error saving position: $error";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _symbolImage = File(pickedFile.path);
        _message = ''; // Clear previous error message
      });
    } else {
      setState(() {
        _message = "No image selected!";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text('Manage Position',style: TextStyle(color: Colors.white),), backgroundColor: Color(0xFF00165a),),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: "Category"),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _positionController,
                decoration: const InputDecoration(labelText: "Position Name"),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _candidateController,
                decoration: const InputDecoration(labelText: "Candidate Name"),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _partyController,
                decoration: const InputDecoration(labelText: "Party Name"),
              ),
              const SizedBox(height: 20),
              _symbolImage != null
                  ? Image.file(
                _symbolImage!,
                height: 150,
              )
                  : const Text("No image selected"),
              ElevatedButton(
                onPressed: pickImage,
                child: const Text("Pick Symbol Image",style: TextStyle(color: Colors.white),),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF00165a),),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : savePosition,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Save Position",style: TextStyle(color: Colors.white),),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF00165a),),
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
      ),
    );
  }
}

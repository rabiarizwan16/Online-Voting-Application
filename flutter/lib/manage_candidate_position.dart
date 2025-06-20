import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ManagePositionCandidatesPage extends StatefulWidget {
  final int positionId;
  final String positionName;
  final String category;

  const ManagePositionCandidatesPage({
    required this.positionId,
    required this.positionName,
    required this.category,
    Key? key,
  }) : super(key: key);

  @override
  _ManagePositionCandidatesPageState createState() =>
      _ManagePositionCandidatesPageState();
}

class _ManagePositionCandidatesPageState
    extends State<ManagePositionCandidatesPage> {
  final TextEditingController _candidateNameController = TextEditingController();
  final TextEditingController _partyNameController = TextEditingController();
  String _message = '';
  File? _imageFile;
  bool _isLoading = false;

  final String _apiUrl = "http://192.168.195.33/php/manageposition.php";

  Future<void> addCandidate() async {
    if (_candidateNameController.text.isEmpty ||
        _partyNameController.text.isEmpty ||
        _imageFile == null) {
      setState(() {
        _message = "All fields, including an image, are required!";
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final request = http.MultipartRequest("POST", Uri.parse(_apiUrl));
      request.fields['position_id'] = widget.positionId.toString();
      request.fields['candidate_name'] = _candidateNameController.text.trim();
      request.fields['party_name'] = _partyNameController.text.trim();

      request.files.add(await http.MultipartFile.fromPath(
        'symbol_image',
        _imageFile!.path,
      ));

      final response = await request.send();
      final responseData = await response.stream.bytesToString();
      final data = jsonDecode(responseData);

      setState(() {
        _message = data['message'];
      });

      if (data['status'] == 'success') {
        _candidateNameController.clear();
        _partyNameController.clear();
        setState(() {
          _imageFile = null;
        });
      }
    } catch (error) {
      setState(() {
        _message = "Error adding candidate: $error";
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
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Manage Candidates for ${widget.positionName}"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _candidateNameController,
                decoration: const InputDecoration(labelText: "Candidate Name"),
              ),
              TextField(
                controller: _partyNameController,
                decoration: const InputDecoration(labelText: "Party Name"),
              ),
              const SizedBox(height: 20),
              _imageFile != null
                  ? Image.file(_imageFile!, height: 150)
                  : const Text("No image selected"),
              ElevatedButton(
                onPressed: pickImage,
                child: const Text("Pick Image"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : addCandidate,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Add Candidate"),
              ),
              const SizedBox(height: 20),
              if (_message.isNotEmpty)
                Text(
                  _message,
                  style: TextStyle(
                    color:
                    _message.contains('success') ? Colors.green : Colors.red,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:camera/camera.dart';
import 'confirm_vote.dart';

class VotePage extends StatefulWidget {
  @override
  _VotePageState createState() => _VotePageState();
}

class _VotePageState extends State<VotePage> {
  final _nameController = TextEditingController();
  final _voterIdController = TextEditingController();
  final _aadhaarController = TextEditingController();

  String? selectedCategory;
  String? selectedPosition;
  String? selectedCandidate;

  List<Map<String, dynamic>> categories = [];
  List<Map<String, dynamic>> positions = [];
  List<Map<String, dynamic>> candidates = [];

  File? _capturedImage;
  bool isFaceMatched = false;
  CameraController? _cameraController;
  List<CameraDescription>? cameras;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
    _initializeCamera();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  // Fetch categories from database
  Future<void> _fetchCategories() async {
    final response = await http.get(Uri.parse('http://192.168.195.33/php/get_categories.php'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        categories = List<Map<String, dynamic>>.from(data);
      });
    }
  }

  Future<void> _fetchPositions(String category) async {
    final response = await http.get(Uri.parse('http://192.168.195.33/php/get_positions.php?category=$category'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        positions = List<Map<String, dynamic>>.from(data);
      });
    }
  }




  Future<void> _fetchCandidates(String positionId) async {
    final response = await http.get(Uri.parse('http://192.168.195.33/php/get_candidates.php?position_id=$positionId'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print("Candidates data: $data");
      setState(() {
        candidates = List<Map<String, dynamic>>.from(data);
      });
    }
  }


  // Initialize front camera
  Future<void> _initializeCamera() async {
    try {
      cameras = await availableCameras();
      if (cameras == null || cameras!.isEmpty) {
        print("No available cameras.");
        return;
      }
      final frontCamera = cameras!.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras!.first,
      );

      _cameraController = CameraController(frontCamera, ResolutionPreset.medium);
      await _cameraController!.initialize();
      if (!mounted) return;
      setState(() {});
    } catch (e) {
      print('Camera initialization error: $e');
    }
  }

  // Capture voter image for face recognition
  Future<void> _captureFace() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      await _initializeCamera();
    }

    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Camera not ready. Try again.')),
      );
      return;
    }

    try {
      final image = await _cameraController!.takePicture();

      setState(() {
        _capturedImage = File(image.path); // ✅ Save the captured image
      });

      await _verifyFace();
    } catch (e) {
      print('Error capturing face: $e');
    }
  }




  Future<void> _verifyFace() async {
    if (_capturedImage == null) {
      print("No image captured");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please capture an image first!')),
      );
      return;
    }
    List<int> imageBytes = await _capturedImage!.readAsBytes();
    String base64Image = base64Encode(imageBytes);


    final uri = Uri.parse('http://192.168.195.33/php/verify_face.php');
    final request = http.MultipartRequest('POST', uri);

    request.fields['voter_id'] = _voterIdController.text.trim();
    request.fields['aadhaar'] = _aadhaarController.text.trim();
    request.fields['name'] = _nameController.text.trim();
    request.fields['uploaded_face'] = base64Image; // Base64 Encoded Image

    request.files.add(await http.MultipartFile.fromPath('image', _capturedImage!.path));

    try {
      final response = await request.send();
      final responseData = await response.stream.bytesToString();

      print("🔥 Face Verification Response: $responseData");

      final data = jsonDecode(responseData);

      if (data.containsKey('status')) {
        setState(() {
          isFaceMatched = data['status'] == 'matched';
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isFaceMatched ? '✅ Face Matched! Proceed to Vote.' : '❌ Face Not Matched! Please try again.'),
            backgroundColor: isFaceMatched ? Colors.green : Colors.red,
          ),
        );
      } else {
        print("⚠️ Unexpected response format: $data");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid response from server.')),
        );
      }
    } catch (e) {
      print("⚠️ Error verifying face: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error verifying face. Please check your internet connection.')),
      );
    }
  }



  Future<String> _convertFaceImageToBase64(File imageFile) async {
    if (imageFile == null) {
      print("⚠️ No image captured.");
      return ""; // Return empty if no image is captured
    }

    File file = File(imageFile.path);
    List<int> imageBytes = await file.readAsBytes();
    return base64Encode(imageBytes);
  }



  // Submit vote
  Future<void> _submitVote() async {
    if (!isFaceMatched) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Face Not Verified!')),
      );
      return;
    }

    // ✅ Check if `_capturedImage` is null before using it
    if (_capturedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No face image captured!')),
      );
      return;
    }

    // ✅ Convert face image to Base64
    String base64Face = await _convertFaceImageToBase64(_capturedImage!);

    // Construct the payload
    final votePayload = jsonEncode({
      'category_id': selectedCategory,
      'position_id': selectedPosition,
      'candidate_id': selectedCandidate,
      'voter_name': _nameController.text.trim(),
      'voter_id': _voterIdController.text.trim(),
      'aadhaar_number': _aadhaarController.text.trim(),
      'uploaded_face': base64Face, // ✅ FIXED: Added face image
    });

    print("🚀 Submitting vote with payload: $votePayload");

    try {
      final response = await http.post(
        Uri.parse("http://192.168.195.33/php/vote.php"),
        headers: {"Content-Type": "application/json"},
        body: votePayload,
      );

      print("✅ HTTP status: ${response.statusCode}");
      print("📩 Response body: ${response.body}");

      final data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => VoteConfirmationScreen()),
        );
      } else {
        print("❌ Vote submission failed: ${data['message']}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to Submit Vote: ${data['message']}')),
        );
      }
    } catch (e) {
      print("⚠️ Error submitting vote: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting vote. Please try again.')),
      );
    }
  }


// // Function to convert face image to Base64
//   Future<String> _convertFaceImageToBase64() async {
//     // Load image from gallery/camera and convert to Base64
//     // Example:
//     // File imageFile = await ImagePicker().pickImage(source: ImageSource.camera);
//     // List<int> imageBytes = await imageFile.readAsBytes();
//     // return base64Encode(imageBytes);
//
//     return ""; // Replace this with actual image conversion logic
//   }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(iconTheme: IconThemeData(color: Color(0xFFE6F7FF)),
        title: Text('Vote',style: TextStyle(color: Color(0xFFE6F7FF)),),
        backgroundColor: Color(0xFF00165a),),
      body: Column(
        children: [
        // Add image after AppBar
        Container(
        width: 160, // Make it cover the full width
        height: 180, // Set a fixed height (adjust as needed)
        child: Image.asset(
          'assets/images/vote_now.png', // Replace with your image path
          fit: BoxFit.cover, // Adjust the fit as per your requirement
        ),
      ),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [

              // Category Dropdown
              DropdownButton<String>(
                value: selectedCategory,
                hint: Text('Select Category'),
                onChanged: (value) {
                  print("Category Selected: $value");  // Debugging

                  setState(() {
                    selectedCategory = value;
                    selectedPosition = null;
                    selectedCandidate = null;
                    positions = [];
                    candidates = [];
                  });

                  if (value != null) {
                    _fetchPositions(value);
                  }
                },
                items: categories.map((category) {
                  return DropdownMenuItem(
                    value: category['category_id'].toString(),
                    child: Text(category['category_name']),
                  );
                }).toList(),
              ),




              DropdownButton<String>(
                value: selectedPosition,
                hint: Text('Select Position'),
                onChanged: (value) {
                  setState(() {
                    selectedPosition = value;
                    selectedCandidate = null; // Reset candidate when position changes.
                    candidates = []; // Clear the candidates list.
                  });
                  _fetchCandidates(value!);
                },
                items: positions.isNotEmpty
                    ? positions.map((position) {
                  return DropdownMenuItem(
                    value: position['id'].toString(), // Use 'id' from positions table.
                    child: Text(position['position_name']), // Display position_name.
                  );
                }).toList()
                    : [],
              ),


              // Candidate Dropdown
              DropdownButton<String>(
                value: selectedCandidate,
                hint: Text('Select Candidate'),
                onChanged: (value) {
                  setState(() {
                    selectedCandidate = value;
                  });
                },
                items: candidates.map((candidate) {
                  return DropdownMenuItem(
                    value: candidate['id'].toString(),
                    child: Row(
                      children: [
                        Image.network(
                          'http://192.168.195.33/php/' + candidate['symbol_image'],
                          width: 40, height: 40, fit: BoxFit.cover,
                        ),
                        SizedBox(width: 10),
                        Text(candidate['name']),
                      ],
                    ),
                  );
                }).toList(),
              ),

              // Voter Information
              TextField(controller: _nameController, decoration: InputDecoration(labelText: 'Voter Name')),
              TextField(controller: _voterIdController, decoration: InputDecoration(labelText: 'Voter ID')),
              TextField(controller: _aadhaarController, decoration: InputDecoration(labelText: 'Aadhaar Number')),

              // Display captured face
              _capturedImage != null ? Image.file(_capturedImage!) : Container(),

              // Capture Face Button
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _captureFace,
                child: Text("Capture Face",style: TextStyle(color: Colors.white),),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF00165a),),
              ),
              SizedBox(
              width: double.infinity, // Make the button full width
            child: ElevatedButton(
            onPressed: _submitVote,
            style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 16), // Make it taller like EVM button
            backgroundColor: Colors.green, // EVM buttons are usually green
            shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            ),
            ),
            child: Row(
            mainAxisSize: MainAxisSize.min, // Adjust button size to fit content
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            if (selectedCandidate != null)
            Image.network('http://192.168.195.33/php/' + candidates.firstWhere(
            (candidate) => candidate['id'].toString() == selectedCandidate,
            orElse: () => {'symbol_image': ''},
            )['symbol_image'],
            width: 40,
            height: 40,
            fit: BoxFit.cover,
            ),
            SizedBox(width: 10), // Space between image and text
            Text(
            'Submit Vote',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            ],
            ),
            ),
            ),
          ]
        ),
            ),
      ),
      ]
    ),
    );
  }
}

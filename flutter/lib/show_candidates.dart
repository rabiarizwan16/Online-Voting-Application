import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CandidatesPage extends StatefulWidget {
  @override
  _CandidatesPageState createState() => _CandidatesPageState();
}

class _CandidatesPageState extends State<CandidatesPage> {
  List<dynamic> candidates = [];
  List<dynamic> positions = [];
  int selectedPositionId = 0; // 0 means all positions

  @override
  void initState() {
    super.initState();
    fetchPositions(); // Load positions from database
    fetchCandidates(); // Load candidates from database
  }

  // Fetch positions dynamically from database
  Future<void> fetchPositions() async {
    final response = await http.get(Uri.parse('http://192.168.195.33/php/show_positions.php'));
    if (response.statusCode == 200) {
      setState(() {
        positions = json.decode(response.body);
      });
    }
  }

  // Fetch candidates based on selected position
  Future<void> fetchCandidates() async {
    String url = 'http://192.168.195.33/php/show_candidates.php';

    if (selectedPositionId > 0) {
      url += '?position_id=$selectedPositionId';  // Pass position ID
    }

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      setState(() {
        candidates = json.decode(response.body);
      });
    } else {
      setState(() {
        candidates = [];  // Clear candidates if request fails
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(title: Text("Candidates",style: TextStyle(color:  Colors.white),),
      backgroundColor: Color(0xFF00165a),
          iconTheme: IconThemeData(color: Colors.white),),
      body: Column(
        children: [
          // Dropdown for Position Selection
          Padding(
            padding: EdgeInsets.all(10),
            child: DropdownButton<int>(
              value: selectedPositionId,

              items: [
                DropdownMenuItem(value: 0, child: Text("All Positions")), // Default option
                ...positions.map((pos) =>DropdownMenuItem(

                  value: pos["id"] is int ? pos["id"] : int.parse(pos["id"].toString()), // Ensure it's an integer
                  child: Text(pos["name"]),
                )
                )
              ],
              onChanged: (value) {
                setState(() {
                  selectedPositionId = value!;
                  fetchCandidates(); // Refresh candidates
                });
              },
            ),
          ),
          Expanded(
            child: candidates.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
              itemCount: candidates.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    leading: Image.network(
                  "http://192.168.195.33/php/" + candidates[index]['candidate_symbol_image_path'], // Add base URL
                    width: 50,
                    height: 50,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.error, size: 50); // Show error icon if image fails
                    },
                  ),

                  title: Text(
                      candidates[index]['candidate_name'],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text("Party: ${candidates[index]['party_name']}"),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

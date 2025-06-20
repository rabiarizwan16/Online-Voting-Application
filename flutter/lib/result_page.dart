import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class VotingResultsPage extends StatefulWidget {
  @override
  _VotingResultsPageState createState() => _VotingResultsPageState();
}

class _VotingResultsPageState extends State<VotingResultsPage> {
  List results = [];
  List charts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchResults();
  }

  Future<void> fetchResults() async {
    final url = Uri.parse("http://192.168.195.33/php/get_result.php");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body); // ✅ Decode as List

      setState(() {
        results = data; // ✅ Store full list
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        iconTheme: IconThemeData(color: Color(0xFFE6F7FF)),
        title: Text("Election Results",style: TextStyle(color: Color(0xFFE6F7FF)),),
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
        ],),
      body: Container(
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : results.isEmpty
            ? Center(child: Text("No results available"))
            : ListView(
          children: [
            // Header Image: Using BoxFit.contain to show full image
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                // Set a fixed height, adjust as needed
                height: 200,
                width: double.infinity,
                child: Image.asset(
                  'assets/images/result-Photoroom.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),

            // Display voting result cards
            ...results.map<Widget>((result) {
              final category = result["category"];
              final position = result["position"];
              final candidates = result["candidates"] as List;
              return Padding(
                padding: const EdgeInsets.only(top: 18.0),
                child: Card(
                  // color: Color(0xFFE6F7FF),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(
                          "$category - $position",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      ...candidates.map<Widget>((candidate) {
                        return ListTile(
                          title: Text(candidate["candidate_name"]),
                          trailing: Text("Votes: ${candidate["votes"]}"),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );



  }
}
















// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:fl_chart/fl_chart.dart';
//
// class ResultPage extends StatefulWidget {
//   @override
//   _ResultPageState createState() => _ResultPageState();
// }
//
// class _ResultPageState extends State<ResultPage> {
//   List<dynamic> results = [];
//
//   @override
//   void initState() {
//     super.initState();
//     fetchResults();
//   }
//
//   Future<void> fetchResults() async {
//     final response = await http.get(Uri.parse("http://192.168.0.107/php/get_results.php"));
//
//     if (response.statusCode == 200) {
//       setState(() {
//         results = json.decode(response.body);
//       });
//     } else {
//       throw Exception("Failed to load results");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Election Results")),
//       body: results.isEmpty
//           ? Center(child: CircularProgressIndicator())
//           : ListView.builder(
//         itemCount: results.length,
//         itemBuilder: (context, index) {
//           var category = results[index]["category"];
//           var position = results[index]["position"];
//           var candidates = results[index]["candidates"];
//
//           return Card(
//             margin: EdgeInsets.all(10),
//             child: Padding(
//               padding: EdgeInsets.all(10),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "$category - $position",
//                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(height: 10),
//                   SizedBox(
//                     height: 200,
//                     child: BarChart(
//                       BarChartData(
//                         barGroups: candidates.asMap().entries.map<BarChartGroupData>((entry) {
//                           int idx = entry.key;
//                           var candidate = entry.value;
//
//                           return BarChartGroupData(
//                             x: idx,
//                             barRods: [
//                               BarChartRodData(
//                                 toY: candidate["votes"].toDouble(), // Updated from 'y' to 'toY'
//                                 color: Colors.blue,
//                                 width: 15,
//                                 borderRadius: BorderRadius.circular(4),
//                               ),
//                             ],
//                             showingTooltipIndicators: [0],
//                           );
//                         }).toList(),
//                         titlesData: FlTitlesData(
//                           leftTitles: AxisTitles(
//                             sideTitles: SideTitles(
//                               showTitles: true,
//                               getTitlesWidget: (value, meta) => Text(value.toInt().toString()),
//                               reservedSize: 40,
//                             ),
//                           ),
//                           bottomTitles: AxisTitles(
//                             sideTitles: SideTitles(
//                               showTitles: true,
//                               getTitlesWidget: (value, meta) {
//                                 int idx = value.toInt();
//                                 if (idx >= 0 && idx < candidates.length) {
//                                   return RotatedBox(
//                                     quarterTurns: 1, // Rotates text for better readability
//                                     child: Text(candidates[idx]["candidate_name"]),
//                                   );
//                                 }
//                                 return Text("");
//                               },
//                               reservedSize: 50,
//                             ),
//                           ),
//                         ),
//                         borderData: FlBorderData(show: false),
//                         barTouchData: BarTouchData(enabled: true),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

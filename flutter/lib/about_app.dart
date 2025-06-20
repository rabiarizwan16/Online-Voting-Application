import 'package:flutter/material.dart';

class AboutApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("About SureVote")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "SureVote - Secure Online Voting App",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "SureVote ensures a transparent and secure online voting experience "
                  "using face recognition, real-time analytics, and fraud prevention mechanisms.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text("Key Features:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            _buildFeature("✅ Secure Face Recognition"),
            _buildFeature("✅ One-Vote-Per-User Restriction"),
            _buildFeature("✅ Real-Time Dashboard"),
            _buildFeature("✅ OTP Authentication (Future Scope)"),
            _buildFeature("✅ Multi-Language Support"),
          ],
        ),
      ),
    );
  }

  Widget _buildFeature(String feature) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.green),
          SizedBox(width: 8),
          Expanded(child: Text(feature, style: TextStyle(fontSize: 16))),
        ],
      ),
    );
  }
}

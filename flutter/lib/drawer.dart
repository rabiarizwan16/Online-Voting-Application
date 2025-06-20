import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:surevote/language_page.dart';
import 'dart:convert';

import 'about_app.dart';
import 'first_login.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  String userName = 'Loading...';
  String userEmail = 'Loading...';
  String? userPhone; // Store logged-in user's phone (instead of userId)

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Load stored user data
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userPhone = prefs.getString('phone');
      userName = prefs.getString('name') ?? 'Loading...';
      userEmail = prefs.getString('email') ?? 'Loading...';
    });

    print("🔹 Stored Phone: $userPhone");

    if (userPhone != null) {
      _fetchUserData(userPhone!);
    }
  }

  Future<void> _fetchUserData(String phone) async {
    final url = Uri.parse('http://192.168.195.33/php/get_userdata.php?phone=$phone');
    print("🔹 Fetching data from: $url");

    try {
      final response = await http.get(url);
      print("🔹 Response Code: ${response.statusCode}");
      print("🔹 Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 'success') {
          setState(() {
            userName = data['name'];
            userEmail = data['email'];
          });
        } else {
          print("❌ Error: ${data['message']}");
        }
      } else {
        print("❌ HTTP Error: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Exception: $e");
    }
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear stored user data

    // Navigate to login page after logout
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => NewLoginPage()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Color(0xFF00165a)),
            accountName: Text(userName, style: TextStyle(fontSize: 18)),
            accountEmail: Text(userEmail),
          ),
    // ListTile(
    // leading: Icon(Icons.home),
    // title: Text('Home'),
    // onTap: () {
    // Navigator.pop(context);
    // },
    // ),
    // ListTile(
    // leading: Icon(Icons.settings),
    // title: Text('Settings'),
    // onTap: () {},
    // ),
    ListTile(
    leading: Icon(Icons.language),
    title: Text('Language'),
    onTap: () {
      Navigator.push(context, MaterialPageRoute(builder: (context)=> LanguagePage()));
    },
    ),
    ListTile(
    leading: Icon(Icons.info),
    title: Text('About Us'),
    onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => AboutApp()));
  },
    ),
    Divider(),
    ListTile(
    leading: Icon(Icons.logout),
    title: Text('Logout'),
    onTap: () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear user session
   Navigator.push(context, MaterialPageRoute(builder: (context)=>NewLoginPage()));// Navigate to login
    },
    ),
    ],
    ),
    );
    }
}

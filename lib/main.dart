

import 'dart:convert';
import 'package:flutter/foundation.dart'; // for compute if needed later
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:md_store/AdminPage.dart';
import 'package:md_store/userPage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Limit global image cache size (good for memory)
  PaintingBinding.instance.imageCache!
    ..maximumSize = 50
    ..maximumSizeBytes = 20 * 1024 * 1024; // 20 MB

  runApp(const MyApp());
}

class Users {
  final String user;
  final String password;

  const Users({
    required this.password,
    required this.user,
  });

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(password: json['pass'], user: json['username']);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login Page',
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _passwordController = TextEditingController();

  bool _obscurePassword = true;
  final Map<String, String> _credentials = {}; // replaces users + passwords
  String? _selectedUser;
  Color _errorColor = Colors.black;

  @override
  void initState() {
    super.initState();
    _getUsers();
  }

  @override
  void dispose() {
    _passwordController.dispose(); // prevent leaks
    super.dispose();
  }

  Future<void> _getUsers() async {
    const headers = {
      'Authorization': 'Basic TURfU1RPUkU6T21hciMyMjIyMDcj'
    };

    try {
      final response = await http.get(
        Uri.parse(
            'https://g7bac86685e277f-omarbase.adb.eu-frankfurt-1.oraclecloudapps.com/ords/md_store/users/'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data =
            jsonDecode(response.body)['items'] as List<dynamic>? ?? [];

        final creds = <String, String>{};
        for (var item in data) {
          final user = Users.fromJson(item);
          creds[user.user] = user.password;
          if (kDebugMode) {
            debugPrint('${user.user} - ${user.password}');
          }
        }

        setState(() {
          _credentials.clear();
          _credentials.addAll(creds);
        });
      } else {
        if (kDebugMode) {
          debugPrint("Error: ${response.reasonPhrase}");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint("Exception: $e");
      }
    }
  }

  void _login() {
    final pass = _passwordController.text.trim();
    final user = _selectedUser;

    if ((user == null || user.isEmpty) || pass.isEmpty) {
      if (kDebugMode) debugPrint("Empty fields");
      return;
    }

    if (_credentials[user] == pass) {
      if (user == "Admin") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AdminPage(),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => UserPage(user: user),
          ),
        );
      }
    } else {
      setState(() {
        _errorColor = Colors.red;
      });
       ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Wrong Password",style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold)),
       ));
      if (kDebugMode) debugPrint("Wrong password");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.redAccent, Colors.cyan],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: kToolbarHeight + 20),
                const Icon(Icons.lock_outline,
                    size: 80, color: Colors.indigo),
                const SizedBox(height: 20),
                const Text(
                  "Welcome Back",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 30),
                DropdownButtonFormField<String>(
                  iconEnabledColor: Colors.black,
                  decoration:  InputDecoration(
                    
                    labelText: 'Username',
                    labelStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                                                                borderRadius: BorderRadius.circular(12),

                    ),

                  ),
                  items: _credentials.keys.map((user) {
                    return DropdownMenuItem(
                      value: user,
                      child: Text(user),
                    );
                  }).toList(),
                  initialValue: _selectedUser,
                  onChanged: (value) {
                    setState(() {
                      _selectedUser = value;
                    });
                  },
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: _errorColor),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                    ),
                    child: const Text(
                      "Login",
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

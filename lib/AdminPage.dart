import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:restart_app/restart_app.dart';
import 'package:md_store/dayDetails.dart';
class Date {
  final String date;
  const Date({required this.date});

  factory Date.fromJson(Map<String, dynamic> json) =>
      Date(date: json['work_day']);
}

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    // ⚠️ Removed extra MaterialApp (saves memory)
    return DateListPage();
  }
}

class users {
  final String username;
  users({required this.username});
  factory users.fromJson(Map<String, dynamic> json) {
    return users(username: json['username']);
  }
}

class DateListPage extends StatefulWidget {
  const DateListPage({super.key});

  @override
  State<DateListPage> createState() => _DateListPageState();
}

class _DateListPageState extends State<DateListPage> {
  bool isLoading = true;
  final List<String> dates = [];

  @override
  void initState() {
    super.initState();
    _loadDates();
  }

  Future<void> _loadDates() async {
    setState(() => isLoading = true);

    const headers = {'Authorization': 'Basic TURfU1RPUkU6T21hciMyMjIyMDcj'};

    try {
      final response = await http.get(
        Uri.parse(
          'https://g7bac86685e277f-omarbase.adb.eu-frankfurt-1.oraclecloudapps.com/ords/md_store/store/getDate',
        ),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final items = jsonDecode(response.body)['items'] as List<dynamic>;
        final fetchedDates = items.map((e) => Date.fromJson(e).date).toList();

        setState(() {
          dates
            ..clear()
            ..addAll(fetchedDates);
        });

        if (kDebugMode) debugPrint("Fetched ${dates.length} dates");
      } else {
        if (kDebugMode) debugPrint("Failed: ${response.reasonPhrase}");
      }
    } catch (e) {
      if (kDebugMode) debugPrint("Error: $e");
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> _showAddUserDialog(BuildContext context) async {
    final usernameController = TextEditingController();
    final passwordController = TextEditingController();
    bool hidePassword = true;
    var isClicked = false;
    late Timer _timer;
    
    Future<void> deleteUser() async {
      debugPrint("clicked delete");
 if(usernameController.text.isEmpty){
    debugPrint("Empty Field");
return;
 }
      const headers = {'Authorization': 'Basic TURfU1RPUkU6T21hciMyMjIyMDcj'};

      try {
        final response = await http.delete(
          Uri.parse(
            'https://g7bac86685e277f-omarbase.adb.eu-frankfurt-1.oraclecloudapps.com/ords/md_store/users/${usernameController.text.trim()}',
          ),
          headers: headers,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.reasonPhrase ?? "Unknown")),
        );
      } catch (e) {
        if (kDebugMode) debugPrint("Delete user error: $e");
      }
    }

    Future<void> addUser() async {

      debugPrint("clicked add");
if(passwordController.text.isEmpty||usernameController.text.isEmpty){
  debugPrint("Empty Field");
  return;
  }
  
      const headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Basic TURfU1RPUkU6T21hciMyMjIyMDcj',
      };

      try {
        final response = await http.post(
          Uri.parse(
            'https://g7bac86685e277f-omarbase.adb.eu-frankfurt-1.oraclecloudapps.com/ords/md_store/users/',
          ),
          headers: headers,
          body: jsonEncode({
            "username": usernameController.text.trim(),
            "pass": passwordController.text.trim(),
          }),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response.reasonPhrase ?? "Unknown")),
        );
      } catch (e) {
        if (kDebugMode) debugPrint("Add user error: $e");
      }
    }

    _startTimer() async {
      _timer = Timer(Duration(milliseconds: 1000), () => isClicked = false);
    }

    await getusers();
    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: Colors.white.withOpacity(
                0.8,
              ), // 👈 semi-transparent
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: const Text("Add User"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      

                      labelText: 'Select or type a username',
                      suffixIcon: PopupMenuButton<String>(
                        icon: Icon(Icons.arrow_drop_down),
                        onSelected: (value) {
                          usernameController.text = value;
                        },
                        itemBuilder: (context) {
                          return usersList.map((e) {
                            return PopupMenuItem(value: e, child: Text(e));
                          }).toList();
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: passwordController,
                    obscureText: hidePassword,
                    decoration: InputDecoration(
                      labelText: "Password",
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          hidePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setDialogState(() => hidePassword = !hidePassword);
                        },
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () async {
                    if (isClicked == false) {
                      _startTimer();
                      isClicked = true;
                             Navigator.pop(context);

                      await deleteUser();
                      usernameController.dispose();
                      passwordController.dispose();
                    }
                  },
                  child: const Text(
                    "Delete",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    if (isClicked == false) {
                      _startTimer();
                      isClicked = true;
                      Navigator.pop(context);
                      await addUser();
                      usernameController.dispose();
                      passwordController.dispose();
                    }
                  },
                  child: const Text("Add"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  List<String> usersList = [];
  Future<void> getusers() async {
    setState(() => isLoading = true);
    setState(() {
      usersList.clear();
    });
    var headers = {'Authorization': 'Basic TURfU1RPUkU6T21hciMyMjIyMDcj'};
    final response = await http.get(
      headers: headers,
      Uri.parse(
        'https://g7bac86685e277f-omarbase.adb.eu-frankfurt-1.oraclecloudapps.com/ords/md_store/store/getusers',
      ),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['items'] as List<dynamic>? ?? [];

      for (var item in data) {
        final user = users.fromJson(item);
        setState(() {
          usersList.add(user.username);
        });
      }
    } else {
      print(response.reasonPhrase);
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: const Text("Welcome Admin"),
          backgroundColor: Colors.transparent,
          actions: [
            IconButton(
              icon: const Icon(Icons.person, color: Colors.black),
              onPressed: () => _showAddUserDialog(context),
            ),IconButton(
              icon: const Icon(Icons.login_sharp, color: Colors.black),
              onPressed: () => Restart.restartApp(),
            ),
          ],
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.redAccent, Colors.cyan],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : dates.isEmpty
              ? const Center(child: Text("No Transactions Found"))
              : Column(
                  children: [
                    const SizedBox(height: kToolbarHeight + 20),
      
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: dates.length,
                        itemBuilder: (context, index) {
                          final d = dates[index];
                          return Card(
                            color: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ListTile(
                              leading: const Icon(
                                Icons.calendar_today,
                                color: Colors.black,
                              ),
                              title: Text(
                                d,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                              ),
                              trailing: const Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.black,
                              ),
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => DayDetailsPage(date: d),
                                  maintainState: false,
                                )
                              ).then((_) => _loadDates()), // Refresh on return,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
        ),
    );
  }
}

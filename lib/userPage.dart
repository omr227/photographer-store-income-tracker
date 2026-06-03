import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:ntp/ntp.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const UserPage(user: "",));
}

class UserPage extends StatelessWidget {
  final String user;

  const UserPage({super.key,required this.user});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: FormPage(user:user,),
    );
  }
}

class FormPage extends StatefulWidget {
  final String user;
  const FormPage({required this.user,super.key});

  @override
  State<FormPage> createState() => _FormPageState(user: user);
}

class _FormPageState extends State<FormPage> {
  final String user;
  _FormPageState({required this.user});
  TextEditingController moneyEURO = TextEditingController();
  TextEditingController moneyUS = TextEditingController();
  TextEditingController moneyPOUND = TextEditingController();
  TextEditingController moneyVISA = TextEditingController();
  TextEditingController dresses = TextEditingController();
  bool refresh = false;
String datetime="";
  Future<void> fetchFormattedNtpTime() async {
  DateTime now = await NTP.now();   // Get NTP time
  DateTime utcNow = now.toUtc().add(const Duration(hours: 3)); // Add 1 hour
  // Format as yyyy-MM-ddTHH:mm:ssZ
  final formatter = DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");
  datetime=formatter.format(utcNow);
  
  }
  Future<void> _submit() async {   
   await fetchFormattedNtpTime();
    if (moneyEURO.text.isEmpty ||
        moneyUS.text.isEmpty ||
        moneyPOUND.text.isEmpty ||
        moneyVISA.text.isEmpty ||
        dresses.text.isEmpty) {
      print("empty Textfield");
    } else {
       setState(() {
      refresh = true;
    });var headers = {
  'Content-Type': 'application/json',
  'Authorization': 'Basic TURfU1RPUkU6T21hciMyMjIyMDcj'
};
print("$user ${moneyEURO.text}  ${moneyUS.text}  ${moneyPOUND.text}  ${moneyVISA.text}  ${dresses.text}");
var request = http.Request('POST', Uri.parse('https://g7bac86685e277f-omarbase.adb.eu-frankfurt-1.oraclecloudapps.com/ords/md_store/transactions/'));
request.body = json.encode({
  "username": user,
  "moneyeuro": moneyEURO.text,
  "moneyus": moneyUS.text,
  "moneypound": moneyPOUND.text,
  "moneyvisa": moneyVISA.text,
  "useddresses": dresses.text,
  "workdate": datetime
});

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        setState(() {
         ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${response.reasonPhrase}")),
    );
        });
 
      } else {
        setState(() {
         ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${response.reasonPhrase}")),
    );
        });
        print(response.reasonPhrase);
      }
      
    setState(() {
      refresh = false;
      moneyEURO.text = "";
      moneyPOUND.text = "";
      moneyUS.text = "";
      moneyVISA.text = "";
      dresses.text = "";
    });
    }
    
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.redAccent, Colors.cyan],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: refresh
            ? const Center(child: CircularProgressIndicator(color: Colors.blue))
            : RefreshIndicator(
                onRefresh: _submit,
                backgroundColor: Colors.black,
                color: Colors.blue,
                child: SafeArea(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                       Text(
                        "Welcome $user",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // 👇 Put fields in Expanded with ListView
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: ListView(
                            children: [
                              TextFormField(
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d*\.?\d*'),
                                  ),
                                ],
                                controller: moneyEURO,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  prefixIcon: const Icon(Icons.euro_sharp),
                                ),
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d*\.?\d*'),
                                  ),
                                ],
                                controller: moneyUS,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.attach_money_sharp,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d*\.?\d*'),
                                  ),
                                ],
                                controller: moneyPOUND,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.currency_pound_sharp,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d*\.?\d*'),
                                  ),
                                ],
                                controller: moneyVISA,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  prefixIcon: const Icon(
                                    Icons.credit_card_sharp,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d*\.?\d*'),
                                  ),
                                ],
                                controller: dresses,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  prefixIcon: const Icon(Icons.checkroom_sharp),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // 👇 Button always at bottom
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _submit,
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
                              "Submit",
                              style: TextStyle(fontSize: 18),
                            ),
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

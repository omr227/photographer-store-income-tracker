
import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserTransactionPage extends StatefulWidget {
  final String date;

  const UserTransactionPage({super.key, required this.date});

  @override
  State<UserTransactionPage> createState() =>
      _UserTransactionPageState(date: date);
}

class Details {
  final double moneyeuro;
  final double moneyus;
  final double moneypound;
  final double moneyvisa;
  final double useddresses;
  final String workdate;
  final String user;
  final dynamic id;

  Details({
    required this.id,
    required this.moneyeuro,
    required this.moneyus,
    required this.moneypound,
    required this.useddresses,
    required this.moneyvisa,
    required this.user,
    required this.workdate,
  });

  factory Details.fromJson(Map<dynamic, dynamic> json) {
    return Details(
      moneyeuro: (json['moneyeuro'] as num).toDouble(),
      id: json['transactionrowid'],
      moneyus: (json['moneyus'] as num).toDouble(),
      moneypound: (json['moneypound'] as num).toDouble(),
      useddresses: (json['useddresses'] as num).toDouble(),
      moneyvisa: (json['moneyvisa'] as num).toDouble(),
      user: json['username'] ?? "",
      workdate: json['workdate'] ?? "",
    );
  }
}

class _UserTransactionPageState extends State<UserTransactionPage> {
  final String date;
  _UserTransactionPageState({required this.date});

  List<dynamic> transactions = [];
  bool isLoading = true;
    bool loadAgain=false;

  @override
  void initState() {
    super.initState();
    loadTransactions();
  }

  Future<void> loadTransactions() async {
    setState(() {
      transactions.clear();
      isLoading = true;
    });

    var headers = {'Authorization': 'Basic TURfU1RPUkU6T21hciMyMjIyMDcj'};
    var request = http.Request(
      'GET',
      Uri.parse(
        'https://g7bac86685e277f-omarbase.adb.eu-frankfurt-1.oraclecloudapps.com/ords/md_store/store/getByDate?selecteddate=$date',
      ),
    );
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      final transactionsResponse =
          jsonDecode(await response.stream.bytesToString())['items']
              as List<dynamic>;
      List<Details> parsed = transactionsResponse
          .map((item) => Details.fromJson(item))
          .toList();

      setState(() {
        for (var record in parsed) {
          transactions.add({
            'id': record.id,
            'moneyeuro': record.moneyeuro,
            'moneyus': record.moneyus,
            'moneypound': record.moneypound,
            'moneyvisa': record.moneyvisa,
            'dresses': record.useddresses,
            'username': record.user,
            'workdate': record.workdate
          });
        }
      });
    } else {
      print(response.reasonPhrase);
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> deleteTransaction(String id) async {
    setState(() => loadAgain=true);
    var headers = {
  'Authorization': 'Basic TURfU1RPUkU6T21hciMyMjIyMDcj'
};
var request = http.Request('POST', Uri.parse('https://g7bac86685e277f-omarbase.adb.eu-frankfurt-1.oraclecloudapps.com/ords/md_store/store/deleteTransaction?ID=$id'));

request.headers.addAll(headers);

http.StreamedResponse response = await request.send();

if (response.statusCode == 200) {
  print(await response.stream.bytesToString());
}
else {
  print(response.reasonPhrase);
}


    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${response.reasonPhrase}")),
    );

    await loadTransactions();
  }

  @override
  Widget build(BuildContext context) {
    
      return Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          centerTitle: true,
          title: const Text("All Users Transactions"),
          backgroundColor: Colors.transparent,
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.redAccent, Colors.cyan],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: RefreshIndicator(
            onRefresh: loadTransactions,
            backgroundColor: Colors.black,
            color: Colors.blue,
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.blue),
                  )
                : transactions.isEmpty
                    ? 
                          Center(
                            child: Text(
                              "No transactions found",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.black),
                            ),
                          )
                    : Column(
                        children: [
                          const SizedBox(height: kToolbarHeight),
                          Expanded(
                            child: ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: transactions.length,
                              itemBuilder: (context, index) {
                                final tx = transactions[index];
                                return ClipRRect(
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(
                                        sigmaX: 10, sigmaY: 10),
                                    child:                                Card(
                                    margin: const EdgeInsets.symmetric(vertical: 10),
                                  color: Colors.black12,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 4,
                                   child: Padding(
                                     padding: const EdgeInsets.all(16),
                                     child: Row(
                                       crossAxisAlignment: CrossAxisAlignment.start,
                                       children: [
                                         IconButton(
                                           onPressed: () {
                                             deleteTransaction("${tx['id']}");
                                           },
                                           icon: const Icon(Icons.delete),
                                         ),
                                         const SizedBox(width: 8),
                                         Expanded(
                                           child: Column(
                                             crossAxisAlignment: CrossAxisAlignment.start,
                                             children: [
                                               Text(
                                                 tx["username"] ?? "Unknown User",
                                                 style: const TextStyle(
                                                   fontWeight: FontWeight.bold,
                                                   fontSize: 18,
                                                   color: Colors.black,
                                                 ),
                                               ),
                                               Text(
                                                 tx["workdate"] ?? "",
                                                 style: const TextStyle(fontSize: 16, color: Colors.black),
                                               ),
                                             ],
                                           ),
                                         ),
                                         const SizedBox(width: 12),
                                         Column(
                                           crossAxisAlignment: CrossAxisAlignment.start,
                                           children: [
                                             Text("EURO: ${tx['moneyeuro']}",style: const TextStyle(fontSize: 14, color: Colors.black)),
                                             Text("US: ${tx['moneyus']}",style: const TextStyle(fontSize: 14, color: Colors.black)),
                                             Text("POUND: ${tx['moneypound']}",style: const TextStyle(fontSize: 14, color: Colors.black)),
                                             Text("VISA: ${tx['moneyvisa']}",style: const TextStyle(fontSize: 14, color: Colors.black)),
                                             Text("USED COSTUMES: ${tx['dresses']}",style: const TextStyle(fontSize: 14, color: Colors.black)),
                                           ],
                                         ),
                                       ],
                                     ),
                                   ),
                                 ),
      
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
          ),
        ),
      );
  }
}

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:md_store/AdminPage.dart';
import 'package:md_store/userTransactions.dart';

class Total {
  final double teuro;
  final double tus;
  final double tpound;
  final double tvisa;
  final double tdresses;

  Total({
    required this.teuro,
    required this.tus,
    required this.tpound,
    required this.tdresses,
    required this.tvisa,
  });

  factory Total.fromJson(Map<dynamic, dynamic> json) {
        return Total(
      teuro: (json['teuro'] as num).toDouble(),
      tus: (json['tus'] as num).toDouble(),
      tpound: (json['tpound'] as num).toDouble(),
      tdresses: (json['tdresses'] as num).toDouble(),
      tvisa: (json['tvisa'] as num).toDouble(),
    );
  }
}


class DayDetailsPage extends StatefulWidget {
  final String date;
  const DayDetailsPage({super.key, required this.date});

  @override
  State<DayDetailsPage> createState() => _DayDetailsPageState();
}

class _DayDetailsPageState extends State<DayDetailsPage> {
  final List<String> filters = [
    "eurototal",
    "ustotal",
    "poundtotal",
    "visatotal",
    "totaldresses",
  ];
  final List<dynamic> totals = [];

  @override
  void initState() {
    super.initState();
    print("Loading totals for date in initState: ${widget.date}");
    loadTotals();
  }
  bool isloading=false;
  Future<void> loadTotals() async {
    load(true);
    totals.clear();

    const headers = {'Authorization': 'Basic TURfU1RPUkU6T21hciMyMjIyMDcj'};

   // try {
     
        final response = await http.get(
          Uri.parse(
            'https://g7bac86685e277f-omarbase.adb.eu-frankfurt-1.oraclecloudapps.com/ords/md_store/store/getTotal?selecteddate=${widget.date}',
          ),
          headers: headers,
        );

        if (response.statusCode == 200) {
          final items = jsonDecode(response.body)['items'] as List<dynamic>;
          if(items[0]['teuro']==null){
            if (kDebugMode) {
              debugPrint("teuro is null");
            }
             Navigator.pop(
                context,
              );
          }else{
          final parsed = items.map((e) => Total.fromJson(e)).toList();
          if(parsed.isEmpty){
            if (kDebugMode) {
              debugPrint("Iam empty");
            }
          }else{
          parsed.forEach((total) {
            totals.add(total.teuro);
            totals.add(total.tus);
            totals.add(total.tpound);
            totals.add(total.tvisa);
            totals.add(total.tdresses);
          });}
         load(false);
        }
        }
       
        /*
          } catch (e) {
      if (kDebugMode) debugPrint("Totals error: $e");
      
    }
    */
  }
void  load(bool loading) {
   if (!mounted) return;
   setState(() {
        isloading=loading;
      });
}
  @override
  Widget build(BuildContext context) {
    final icons = [
      Icons.euro,
      Icons.attach_money,
      Icons.currency_pound,
      Icons.credit_card,
      Icons.checkroom,
    ];



    return Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: Text(widget.date),
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
          child: totals.length != filters.length
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: loadTotals,
                  child: Column(
                    children: [
                      const SizedBox(height: kToolbarHeight + 20),
      
                      Expanded(
                        child: ListView.separated(
                          scrollDirection: Axis.vertical,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 20),
                          itemCount: filters.length,
                          padding: const EdgeInsets.all(12),
                          itemBuilder: (context, index) {
                            return Card(
                              color: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                leading: Icon(icons[index], color: Colors.black),
                                title: Text(
                                  "${totals[index]}",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
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
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(12),
          child: ElevatedButton.icon(
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => UserTransactionPage(date: widget.date),
                  maintainState:false,
                ),
              );
            },
            icon: const Icon(Icons.list, color: Colors.black),
            label: const Text(
              "Show All Users Transactions",
              style: TextStyle(color: Colors.black),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:untitled1/screens/result_detail.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({super.key});

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  final storage = const FlutterSecureStorage();

  String username = '';

  @override
  void initState() {
    super.initState();
    storage.read(key: 'username').then((value) {
      setState(() {
        username = value!;
      });
    });
  }

  Future getResults() async {
    var result = await FirebaseFirestore.instance
        .collection('answers')
        .where('username', isEqualTo: username)
        .get();
    return result.docs;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Result'),
        ),
        body: FutureBuilder(
          future: getResults(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return RefreshIndicator(
                onRefresh: () async {
                  setState(() {});
                },
                child: ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                      child: Container(
                        color: Colors.brown[100],
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailResult(
                                  result: snapshot.data[index].id,
                                ),
                              ),
                            );
                          },
                          child: ListTile(
                            leading: Text(snapshot.data[index]
                                .data()['score']
                                .toString()),
                            title: Text(snapshot.data[index]
                                .data()['datetime']
                                .toString()),
                            trailing: snapshot.data[index].data()['score'] > 80
                                ? const Icon(
                                    Icons.sentiment_very_satisfied,
                                    color: Colors.green,
                                  )
                                : snapshot.data[index].data()['score'] > 60 &&
                                        snapshot.data[index].data()['score'] <
                                            80
                                    ? const Icon(
                                        Icons.sentiment_satisfied,
                                        color: Colors.yellow,
                                      )
                                    : const Icon(
                                        Icons.sentiment_very_dissatisfied,
                                        color: Colors.red),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }
          },
        ));
  }
}

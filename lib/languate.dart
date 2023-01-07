import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:untitled1/login.dart';

class LanguatePage extends StatefulWidget {
  const LanguatePage({Key? key}) : super(key: key);

  @override
  State<LanguatePage> createState() => _LanguatePageState();
}

class _LanguatePageState extends State<LanguatePage> {
  String _lang = 'EN';

  final storange = const FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _lang == 'EN' ? 'Select your language' : 'กรุณาเลือกภาษา',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            InkWell(
              onTap: () {
                setState(() {
                  _lang = 'EN';
                });
              },
                child: Text(
                  _lang == 'EN' ? 'English' : 'ภาษาอังกฤษ',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight:
                      _lang == 'EN' ? FontWeight.bold : FontWeight.normal),
            )),
            SizedBox(height: 20),
            InkWell(
              onTap: () {
                setState(() {
                  _lang = 'TH';
                });
              },
              child: Text(
                _lang == 'TH' ?  'ภาษาไทย' : 'Thai',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight:
                        _lang == 'TH' ? FontWeight.bold : FontWeight.normal),
              ),
            ),
            SizedBox(height: 40),
            OutlinedButton(
              onPressed: () {
                storange.write(key: 'langSet', value: _lang);
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                    (route) => false);
              },
              child: Text(_lang == 'EN' ? 'Next' : 'ถัดไป'),
            )
          ],
        ),
      ),
    );
  }
}

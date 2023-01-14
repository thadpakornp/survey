import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:untitled1/login.dart';

import 'localization/language/languages.dart';
import 'localization/locale_constant.dart';
import 'model/language_data.dart';

class LanguatePage extends StatefulWidget {
  const LanguatePage({Key? key}) : super(key: key);

  @override
  State<LanguatePage> createState() => _LanguatePageState();
}

class _LanguatePageState extends State<LanguatePage> {

  final storange = const FlutterSecureStorage();

  Widget _createLanguageDropDown() {
    return DropdownButton<LanguageData>(
      iconSize: 30,
      hint: Text(Languages.of(context)!.labelSelectLanguage),
      onChanged: (LanguageData? language) {
        changeLanguage(context, language!.languageCode);
        storange.write(key: 'langSet', value: language.languageCode);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const LoginPage()));
      },
      items: LanguageData.languageList()
          .map<DropdownMenuItem<LanguageData>>(
            (e) => DropdownMenuItem<LanguageData>(
              value: e,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[Text(e.name)],
              ),
            ),
          )
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(children: <Widget>[
          SizedBox(
            height: 80,
          ),
          Text(
            Languages.of(context)!.labelWelcome,
            style: TextStyle(
                fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          SizedBox(
            height: 30,
          ),
          Text(
            Languages.of(context)!.labelInfo,
            style: TextStyle(fontSize: 20, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 70,
          ),
          _createLanguageDropDown(),
        ]),
      ),
    );
  }
}

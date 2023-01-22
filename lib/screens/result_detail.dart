import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:untitled1/localization/language/languages.dart';

class DetailResult extends StatefulWidget {
  final String result;

  const DetailResult({super.key, required this.result});

  @override
  State<DetailResult> createState() => _DetailResultState(result);
}

class _DetailResultState extends State<DetailResult> {
  final String result;

  _DetailResultState(this.result);

  String? username;
  String? sex;
  String? smoking;
  String? smokingNumber;
  String? sick;

  @override
  void initState() {
    super.initState();
    getResults();
  }

  Future getResults() async {
    var data = await FirebaseFirestore.instance
        .collection('answers')
        .doc(result)
        .get();
    setState(() {
      sex = data.data()!['sex'];
      smoking = data.data()!['smoking'];
      smokingNumber = data.data()!['smokingNumber'];
      sick = data.data()!['sick'];
    });
  }

  Widget _QuestionOne() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Languages.of(context)!.labelYourGender,
          style: TextStyle(fontSize: 20),
        ),
        RadioListTile(
          title: Text('ชาย'),
          value: 'Male',
          groupValue: sex,
          onChanged: (value) {},
        ),
        RadioListTile(
          title: Text('หญิง'),
          value: 'Female',
          groupValue: sex,
          onChanged: (value) {},
        ),
      ],
    );
  }

  Widget _QuestionTwo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'สูบบุหรี่หรือไม่?',
          style: TextStyle(fontSize: 20),
        ),
        RadioListTile(
          title: Text('สูบตลอด'),
          value: 'Alway',
          groupValue: smoking,
          onChanged: (value) {},
        ),
        RadioListTile(
          title: Text('บางครั้ง'),
          value: 'Sometime',
          groupValue: smoking,
          onChanged: (value) {},
        ),
        RadioListTile(
          title: Text('ไม่สูบ'),
          value: 'Never',
          groupValue: smoking,
          onChanged: (value) {},
        ),
      ],
    );
  }

  Widget _QuestionTwoOptional() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ภายใน 1 เดือนที่ผ่านมา ท่านสูบประมาณกี่ตัว?',
          style: TextStyle(fontSize: 20),
        ),
        RadioListTile(
          title: Text('มากกว่า 50 ตัว'),
          value: 'มากกว่า 50 ตัว',
          groupValue: smokingNumber,
          onChanged: (value) {},
        ),
        RadioListTile(
          title: Text('มากกว่า 20 ตัว'),
          value: 'มากกว่า 20 ตัว',
          groupValue: smokingNumber,
          onChanged: (value) {},
        ),
        RadioListTile(
          title: Text('น้อยกว่า 20 ตัว'),
          value: 'น้อยกว่า 20 ตัว',
          groupValue: smokingNumber,
          onChanged: (value) {},
        ),
      ],
    );
  }

  Widget _QuestionTwoOptionalTwo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'คุณเคยมีอาการไอเป็นเลือดหรือไอติดต่อกันเป็นเดือนหรือไม่?',
          style: TextStyle(fontSize: 20),
        ),
        RadioListTile(
          title: Text('เคย'),
          value: 'เคย',
          groupValue: sick,
          onChanged: (value) {},
        ),
        RadioListTile(
          title: Text('ไม่เคย'),
          value: 'ไม่เคย',
          groupValue: sick,
          onChanged: (value) {},
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(result),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _QuestionOne(),
              SizedBox(
                height: 15,
              ),
              _QuestionTwo(),
              SizedBox(
                height: 15,
              ),
              smoking == 'Never' || smoking == null
                  ? Container()
                  : _QuestionTwoOptional(),
              SizedBox(
                height: 15,
              ),
              smoking == 'Alway' && smokingNumber == 'มากกว่า 50 ตัว'
                  ? _QuestionTwoOptionalTwo()
                  : Container(),
              SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

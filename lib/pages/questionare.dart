import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class QuestionPage extends StatefulWidget {
  const QuestionPage({Key? key}) : super(key: key);

  @override
  State<QuestionPage> createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  String? username;
  String? sex;
  String? smoking;
  String? smokingNumber;
  String? sick;

  late String _txt = '';
  late int score = 100;

  final _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _storage.read(key: 'username').then((value) {
      setState(() {
        username = value;
      });
    });
  }

  Widget _QuestionOne() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'เพศของคุณ?',
          style: TextStyle(fontSize: 20),
        ),
        RadioListTile(
          title: Text('ชาย'),
          value: 'Male',
          groupValue: sex,
          onChanged: (value) {
            setState(() {
              sex = value.toString();
            });
          },
        ),
        RadioListTile(
          title: Text('หญิง'),
          value: 'Female',
          groupValue: sex,
          onChanged: (value) {
            setState(() {
              sex = value.toString();
            });
          },
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
          onChanged: (value) {
            setState(() {
              smoking = value.toString();
            });
          },
        ),
        RadioListTile(
          title: Text('บางครั้ง'),
          value: 'Sometime',
          groupValue: smoking,
          onChanged: (value) {
            setState(() {
              smoking = value.toString();
            });
          },
        ),
        RadioListTile(
          title: Text('ไม่สูบ'),
          value: 'Never',
          groupValue: smoking,
          onChanged: (value) {
            setState(() {
              smoking = value.toString();
              smokingNumber = null;
            });
          },
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
          onChanged: (value) {
            setState(() {
              smokingNumber = value.toString();
            });
          },
        ),
        RadioListTile(
          title: Text('มากกว่า 20 ตัว'),
          value: 'มากกว่า 20 ตัว',
          groupValue: smokingNumber,
          onChanged: (value) {
            setState(() {
              smokingNumber = value.toString();
              sick = null;
            });
          },
        ),
        RadioListTile(
          title: Text('น้อยกว่า 20 ตัว'),
          value: 'น้อยกว่า 20 ตัว',
          groupValue: smokingNumber,
          onChanged: (value) {
            setState(() {
              smokingNumber = value.toString();
              sick = null;
            });
          },
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
          onChanged: (value) {
            setState(() {
              sick = value.toString();
            });
          },
        ),
        RadioListTile(
          title: Text('ไม่เคย'),
          value: 'ไม่เคย',
          groupValue: sick,
          onChanged: (value) {
            setState(() {
              sick = value.toString();
            });
          },
        ),
      ],
    );
  }

  Future _insertData() async {
    FirebaseFirestore.instance
        .collection('answers')
        .doc()
        .set({
          'username': username,
          'datetime': DateTime.now(),
          'sex': sex,
          'smoking': smoking,
          'smokingNumber': smokingNumber,
          'sick': sick,
    }).then((value) {
      showDialog(context: context, builder: (BuildContext context) {
        return AlertDialog(
          title: Text('บันทึกข้อมูลเรียบร้อย'),
          actions: [
            TextButton(
              child: Text('กลับหน้าแรก'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('ผลประเมิน'),
              onPressed: () {
                Navigator.of(context).pop();
                _countData();
              },
            ),
          ],
        );
      });
    })
    .catchError((error) => print('error'));
  }

  void _countData() {
    if (smoking != 'Never') {
      if (smoking == 'Alway') {
        setState(() {
          score -= 10;
        });
      } else {
        setState(() {
          score -= 5;
        });
      }

      if (smokingNumber == 'มากกว่า 50 ตัว') {
        setState(() {
          score -= 20;
        });
      } else if (smokingNumber == 'มากกว่า 20 ตัว') {
        setState(() {
          score -= 10;
        });
      } else {
        setState(() {
          score -= 5;
        });
      }

      if (sick == 'เคย') {
        setState(() {
          score -= 30;
        });
      }

      if (score >= 90) {
        setState(() {
          _txt = 'คุณมีความเสี่ยงต่ำ';
        });
      } else if (score <= 70 && score >= 50) {
        setState(() {
          _txt = 'คุณมีความเสี่ยงปานกลาง';
        });
      } else if (score < 50) {
        setState(() {
          _txt = 'คุณมีความเสี่ยงสูง';
        });
      }
    } else {
      setState(() {
        _txt = 'คุณมีความเสี่ยงต่ำ';
      });
    }

    print(score);

    showDialog(context: context, builder: (BuildContext context) {
      return AlertDialog(
        title: Text(_txt),
        actions: [
          TextButton(
            child: Text('กลับหน้าแรก'),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('เริ่มทำแบบสอบถาม'),
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
              Center(
                child: OutlinedButton(
                  onPressed: () {
                    if (smoking != 'Never' && smokingNumber == null) {
                      SnackBar snackBar = SnackBar(
                        content: Text('กรุณาเลือกจำนวนบุหรี่'),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else if (smoking == 'Alway' && smokingNumber == 'มากกว่า 50 ตัว' && sick == null) {
                      SnackBar snackBar = SnackBar(
                        content: Text('กรุณาเลือกคำตอบ'),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else {
                      _insertData();
                    }
                  },
                  child: Text('ส่งแบบสอบถาม'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

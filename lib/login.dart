import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:untitled1/languate.dart';
import 'package:untitled1/localization/language/languages.dart';
import 'package:untitled1/main.dart';
import 'package:untitled1/register.dart';
import 'package:untitled1/screens/homePage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _storage.read(key: 'login').then((value) {
      if (value == 'true') {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const MyWidget()),
            (route) => false);
      }
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future _login() async {
    FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: _usernameController.text)
        .get()
        .then((value) {
      if (value.docs.isEmpty) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('User not found')));
      } else {
        if (value.docs[0].data()['password'] == _passwordController.text) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Login successful')));
          _storage.write(key: 'login', value: 'true');
          _storage.write(
              key: 'username', value: value.docs[0].data()['username']);
          _storage.write(key: 'phone', value: value.docs[0].data()['phone']);
          _storage.write(key: 'name', value: value.docs[0].data()['firstName']);
          _storage.write(
              key: 'surname', value: value.docs[0].data()['lastName']);
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const MyWidget()),
              (route) => false);
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Wrong password')));
        }
      }
    });
  }

  Future _loginWithGoogle() async {
    GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );

    GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: googleUser?.id.toString())
        .get()
        .then((value) {
      if (value.docs.isEmpty) {
        // insert to firestore
        FirebaseFirestore.instance.collection('users').doc().set({
          'username': googleUser?.id.toString(),
          'password': Random().nextInt(1000000).toString(),
          'firstName': googleUser?.displayName.toString(),
          'lastName': '',
          'phone': '',
        }).then((value) {
          //success
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Login successful')));
          _storage.write(key: 'login', value: 'true');
          _storage.write(key: 'username', value: googleUser?.id.toString());
          _storage.write(key: 'phone', value: '');
          _storage.write(
              key: 'name', value: googleUser?.displayName.toString());
          _storage.write(key: 'surname', value: '');
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const MyWidget()),
              (route) => false);
        }).catchError((error) {
          //error
          SnackBar snackBar = SnackBar(content: Text('Error: $error'));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        });
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Login successful')));
        _storage.write(key: 'login', value: 'true');
        _storage.write(key: 'username', value: googleUser?.id.toString());
        _storage.write(key: 'phone', value: '');
        _storage.write(key: 'name', value: googleUser?.displayName.toString());
        _storage.write(key: 'surname', value: '');
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const MyWidget()),
            (route) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.arrow_back),
                InkWell(
                    child: Text(Languages.of(context)!.appName),
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LanguatePage(),
                        ),
                      );
                    }),
              ],
            ),
            const SizedBox(height: 10),
            Image.network(
                'https://blog.logrocket.com/wp-content/uploads/2022/02/Best-IDEs-Flutter-2022.png'),
            const SizedBox(height: 10),
            Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(Languages.of(context)!.usernameLogin,
                          style: const TextStyle(fontSize: 20)),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _usernameController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Username',
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(Languages.of(context)!.passwordLogin,
                          style: TextStyle(fontSize: 20)),
                      const SizedBox(height: 10),
                      TextField(
                        obscureText: true,
                        controller: _passwordController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Password',
                        ),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: ElevatedButton(
                          onPressed: _login,
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.lightGreen),
                          ),
                          child: const Text('Login'),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: TextButton(
                          onPressed: null,
                          style: ButtonStyle(
                            foregroundColor:
                                MaterialStateProperty.all(Colors.lightGreen),
                          ),
                          child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RegisterPage()),
                                ).then((value) {
                                  if (value != null) {
                                    _usernameController.text = value;
                                    SnackBar snackBar = const SnackBar(
                                        content:
                                            Text('Registered Successfully'));
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  }
                                });
                              },
                              child: const Text('Register')),
                        ),
                      ),
                      const Center(child: Text('or login with')),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: null,
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.blue),
                            ),
                            child: const Text('Facebook'),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: _loginWithGoogle,
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.red),
                            ),
                            child: const Text('Google'),
                          ),
                        ],
                      ),
                    ]),
              ),
            ),
          ],
        ),
      )),
    );
  }
}

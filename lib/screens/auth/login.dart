import 'package:ctse_app/screens/auth/register.dart';
import 'package:ctse_app/services/validators.dart';
import 'package:flutter/material.dart';

import '../../services/auth.dart';
import '../home.dart';

class EmailSignin extends StatefulWidget {
  const EmailSignin({Key? key}) : super(key: key);

  @override
  State<EmailSignin> createState() => _EmailSigninState();
}

class _EmailSigninState extends State<EmailSignin> {
  bool isLoading = false;
  final AuthService _auth = AuthService();
  final _signInFormKey = GlobalKey<FormState>();

  final TextEditingController email = TextEditingController();
  final TextEditingController pass = TextEditingController();

  @override
  Widget build(BuildContext context) => isLoading
      ? const LoadingPage()
      : Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
              child: Form(
                  key: _signInFormKey,
                  autovalidateMode: AutovalidateMode.always,
                  onChanged: () {
                    Form.of(primaryFocus!.context!).save();
                  },
                  child: Wrap(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Padding(
                              padding:
                                  EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 25.0),
                              child: Center(
                                child: Text(
                                  'LOGIN',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30.0,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                            ),
                            const Center(
                              child: Image(
                                width: 250,
                                height: 250,
                                image: AssetImage('assets/dashboard.png'),
                              ),
                            ),
                            TextFormField(
                              controller: email,
                              decoration: const InputDecoration(
                                hintText: 'What is your email',
                                labelText: 'Email *',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Enter an email';
                                }
                                if (!value.isValidEmail()) {
                                  return 'Enter Valid Email';
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              controller: pass,
                              obscureText: true,
                              decoration: const InputDecoration(
                                hintText: 'Enter a Strong Password',
                                labelText: 'Password *',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Enter a password';
                                }
                                return null;
                              },
                            ),
                            Container(
                                height: 70,
                                padding:
                                    const EdgeInsets.fromLTRB(10, 20, 10, 0),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: Size.fromHeight(
                                        40), // fromHeight use double.infinity as width and 40 is the height
                                  ),
                                  child: const Text('Login'),
                                  onPressed: () async {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    dynamic result = await _auth.signInEmail(
                                        email.text, pass.text);
                                    if (result == 'Success') {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text('Successfully Signed In'),
                                      ));
                                      setState(() {
                                        isLoading = false;
                                      });
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => const Home()));
                                    } else {
                                      setState(() {
                                        isLoading = false;
                                      });
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(new SnackBar(
                                        content: new Text(result),
                                      ));
                                    }
                                  },
                                )),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                const Text('Does not have account?'),
                                TextButton(
                                  child: const Text(
                                    'Register',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  onPressed: () async {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) => const Register()));
                                  },
                                )
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ))));
}

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      // backgroundColor: ,
      body: Center(
        child: CircularProgressIndicator(
          color: Colors.blueAccent,
        ),
      ),
    );
  }
}

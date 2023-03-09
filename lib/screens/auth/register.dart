import 'package:ctse_app/services/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../services/auth.dart';
import 'login.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService auth = AuthService();

  bool isLoading = false;

  final registrationFormUser = GlobalKey<FormState>();
  final TextEditingController firstName = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController pass = TextEditingController();
  final TextEditingController confirmPass = TextEditingController();

  @override
  Widget build(BuildContext context) => isLoading
      ? const LoadingPage()
      : Scaffold(
          body: SingleChildScrollView(
          child: Form(
              key: registrationFormUser,
              autovalidateMode: AutovalidateMode.always,
              onChanged: () {
                Form.of(primaryFocus!.context!).save();
              },
              child: Wrap(
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 10.0),
                    child: Center(
                      child: Text(
                        'Register',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 40.0,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ),
                  const Center(
                    child: Image(
                      width: 250,
                      height: 250,
                      image: AssetImage('signup.png'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        TextFormField(
                          controller: firstName,
                          decoration: const InputDecoration(
                            hintText: 'What is your first name?',
                            labelText: 'First Name *',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter Your First Name';
                            }
                            if (!value.isValidName()) {
                              return 'Name should not contain any numbers';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: lastName,
                          decoration: const InputDecoration(
                            hintText: 'What is your last name?',
                            labelText: 'Last Name *',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter Your Last Name';
                            }
                            if (!value.isValidName()) {
                              return 'Name should not contain any numbers';
                            }
                            return null;
                          },
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
                        TextFormField(
                          controller: confirmPass,
                          obscureText: true,
                          decoration: const InputDecoration(
                            hintText: 'Enter a Strong Password',
                            labelText: 'Confirm Password *',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter a password';
                            }
                            if (pass.text != confirmPass.text) {
                              return 'Password do not match';
                            }
                            return null;
                          },
                        ),
                        Container(
                            height: 70,
                            padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size.fromHeight(
                                    40), // fromHeight use double.infinity as width and 40 is the height
                              ),
                              child: const Text('Register'),
                              onPressed: () async {
                                if (registrationFormUser.currentState!
                                    .validate()) {
                                  dynamic result = await auth.registerUser(
                                      firstName.text,
                                      lastName.text,
                                      email.text,
                                      pass.text);
                                  print(result);
                                  if (result == 'Success') {
                                    print('Successfully Created Account');
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                      content:
                                          Text('Successfully Created Account'),
                                    ));
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (_) =>
                                                const EmailSignin()));
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text(result),
                                    ));
                                  }
                                }
                              },
                            )),
                      ],
                    ),
                  )
                ],
              )),
        ));
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

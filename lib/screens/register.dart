import 'package:ctse_app/services/validators.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../services/auth.dart';

void main() {
  runApp(const Register());
}

class Register extends StatelessWidget {
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService auth = AuthService();

    final registrationFormKeyLocal = GlobalKey<FormState>();
    final registrationFormKeyForeign = GlobalKey<FormState>();

    final TextEditingController fullName = TextEditingController();
    final TextEditingController nic = TextEditingController();
    final TextEditingController passportNo = TextEditingController();
    final TextEditingController contactNo = TextEditingController();
    final TextEditingController email = TextEditingController();
    final TextEditingController pass = TextEditingController();
    final TextEditingController confirmPass = TextEditingController();

    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          body: Form(
              key: registrationFormKeyLocal,
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
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        TextFormField(
                          controller: fullName,
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
                          controller: fullName,
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
                              child: const Text('Login'),
                              onPressed: () async {
                                // dynamic result = await _auth.signInEmail(emailController.text, passwordController.text);
                                // if(result=='Success'){
                                //   print('done');
                                //   Navigator.push(context, MaterialPageRoute(builder: (_)=> Home()));
                                // }else{
                                //   print(result);
                                // }
                              },
                            )),
                      ],
                    ),
                  )
                ],
              )),
        ),
      ),
    );
  }
}

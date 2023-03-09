// import 'package:ctse_app/services/validators.dart';
import 'package:flutter/material.dart';

class EmailSignin extends StatefulWidget {
  const EmailSignin({Key? key}) : super(key: key);

  @override
  State<EmailSignin> createState() => _EmailSigninState();
}

class _EmailSigninState extends State<EmailSignin> {
  bool isLoading = false;
  // final AuthService _auth = AuthService();
  final _signInFormKey = GlobalKey<FormState>();

  final TextEditingController _email = TextEditingController();
  final TextEditingController _pass = TextEditingController();

  @override
  Widget build(BuildContext context) => isLoading
      ? const LoadingPage()
      : Scaffold(
          backgroundColor: Colors.white,
          body: Form(
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
                          padding: EdgeInsets.fromLTRB(0.0, 25.0, 0.0, 25.0),
                          child: Center(
                            child: Text(
                              'CTSE - LOGIN',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 30.0,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ),
                        // const Padding(padding: EdgeInsets.fromLTRB(0.0,0.0,0.0,25.0),
                        //   child: Center(child: Text('Login',
                        //     style: TextStyle(
                        //       fontWeight: FontWeight.bold,
                        //       fontSize: 40.0,
                        //       color: Colors.black54,
                        //     ),
                        //   ),
                        //   ),
                        // ),
                        const Center(
                          child: Image(
                            width: 250,
                            height: 250,
                            image: AssetImage('todo.png'),
                          ),
                        ),

                        TextFormField(
                          controller: _email,
                          decoration: const InputDecoration(
                            hintText: 'What is your email',
                            labelText: 'Email *',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter an email';
                            }
                            // if (!value.isValidEmail()) {
                            //   return 'Enter Valid Email';
                            // }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _pass,
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
                            padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size.fromHeight(
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
                            SizedBox(height: 20,),
                        Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('Does not have account?'),
                TextButton(
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(fontSize: 14),
                  ),
                  onPressed: () async {
                    // Navigator.push(context, MaterialPageRoute(builder: (_)=> const Register()));
                  },
                )
              ],
            ),
                      ],
                    ),
                  )
                ],
              )));
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

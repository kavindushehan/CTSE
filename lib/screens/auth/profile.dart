import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ctse_app/model/user.dart';
import 'package:ctse_app/services/auth.dart';
import 'package:ctse_app/services/validators.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../model/user.dart';
import '../home.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  final AuthService _auth = AuthService();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  UserModel currentUser = UserModel();

  bool isLoading = false;
  late final String UserId;
  late dynamic result = 'Email';

  final updateUserForm = GlobalKey<FormState>();

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    result = auth.currentUser?.uid;
    isLoading = true;

    setState(() {
      UserId = result!;
      isLoading = false;
    });
    print(UserId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => isLoading
      ? const LoadingPage()
      : Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text('Profile'),
          ),
          body: FutureBuilder<UserModel?>(
            future: readUser(UserId),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final user = snapshot.data;
                return user == null
                    ? const Center(child: Text('No User'))
                    : buildUserForm(user);
              } else {
                return const LoadingPage();
              }
            },
          ));

  Future<UserModel?> readUser(userId) async {
    final docUser = _fireStore.collection("userData").doc(userId);
    final snapshot = await docUser.get();

    if (snapshot.exists) {
      if (kDebugMode) {}

      currentUser = UserModel.fromMap(snapshot.data()!);
      print(currentUser.firstName);
      return currentUser;
    }
    return null;
  }

  Widget buildUserForm(UserModel user) {
    firstNameController.text = user.firstName ?? 'First Name';
    lastNameController.text = user.lastName ?? 'Last Name';
    emailController.text = user.email ?? 'Email';

    return Form(
        key: updateUserForm,
        autovalidateMode: AutovalidateMode.always,
        onChanged: () {
          Form.of(primaryFocus!.context!).save();
        },
        child: Wrap(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 20.0,
              ),
              color: Colors.blue,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    user.firstName ?? 'FirstName',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 38,
                    ),
                  ),
                  const Text(
                    ' ',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 38,
                    ),
                  ),
                  Text(
                    user.lastName ?? 'FirstName',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 38,
                    ),
                  )
                ],
              ),
            ),
            const Center(
              child: Image(
                width: 250,
                height: 250,
                image: AssetImage('change.jpg'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    controller: firstNameController,
                    decoration: const InputDecoration(
                      hintText: 'Edit your First name?',
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
                    controller: lastNameController,
                    decoration: const InputDecoration(
                      hintText: 'Edit your Last name?',
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
                    controller: emailController,
                    decoration: const InputDecoration(
                      hintText: 'Edit your Email?',
                      labelText: 'Email *',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter a email';
                      }
                      if (!value.isValidEmail()) {
                        return 'Phone Number should be a number';
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
                        child: const Text('Update Profile'),
                        onPressed: () async {
                          setState(() {
                            isLoading = true;
                          });
                          dynamic result = await _auth.updateUser(
                              firstNameController.text,
                              lastNameController.text,
                              emailController.text);
                          if (result == 'Success') {
                            setState(() {
                              isLoading = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: new Text(result),
                            ));
                          } else {
                            setState(() {
                              isLoading = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: new Text(result),
                            ));
                          }
                          setState(() {
                            isLoading = false;
                          });
                        },
                      )),
                ],
              ),
            )
          ],
        ));
  }
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

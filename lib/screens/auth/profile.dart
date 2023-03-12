import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ctse_app/models/user.dart';
import 'package:ctse_app/screens/auth/login.dart';
import 'package:ctse_app/home.dart';
import 'package:ctse_app/services/auth.dart';
import 'package:ctse_app/services/validators.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../widgets/loading.dart';

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

  File? _image;
  final _picker = ImagePicker();

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
    super.initState();
  }

  @override
  Widget build(BuildContext context) => isLoading
      ? const LoadingPage()
      : Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: const Text('Profile'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => const Main())),
            ),
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
      return currentUser;
    }
    return null;
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = pickedFile != null ? File(pickedFile.path) : null;
    });
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
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0.0, 20, 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(top: 50.0),
                    child: Center(
                      child: GestureDetector(
                          onTap: _pickImage,
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundImage:
                                    _image != null ? FileImage(_image!) : null,
                                child: _image == null
                                    ? const Text('Add Photo')
                                    : null,
                              ),
                              const SizedBox(height: 10),
                              const Text('Upload Image'),
                            ],
                          )),
                    ),
                  ),
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
                        return 'Please enter a valid name';
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
                        return 'Please enter a valid name';
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
                      height: 50,
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
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
                              emailController.text,
                              _image);
                          if (result == 'Success') {
                            setState(() {
                              isLoading = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: new Text(result),
                              backgroundColor: Colors.blue,
                            ));
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const Main()));
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
                  Container(
                      height: 50,
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          minimumSize: const Size.fromHeight(
                              40), 
                        ),
                        child: const Text('Delete Account'),
                        onPressed: () async {
                          showDialog<String>(
                            context: context,
                            builder: (BuildContext contextF) => AlertDialog(
                              title: const Text('Delete Account'),
                              content: const Text(
                                  'If you delete this account, you will be lost your entered data and this account cannot be recovered again'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(contextF, 'Cancel'),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    Navigator.pop(contextF, 'OK');
                                    dynamic result = await _auth.deleteUser();
                                    print(result);
                                    if (result == 'Success') {
                                      setState(() {
                                        isLoading = false;
                                      });
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => EmailSignin()));
                                    } else {
                                      setState(() {
                                        isLoading = false;
                                      });
                                      print('Error');
                                    }
                                  },
                                  child: const Text(
                                    'Delete',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      )),
                ],
              ),
            )
          ],
        ));
  }
}


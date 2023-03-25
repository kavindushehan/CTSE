import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ctse_app/models/user.dart';
import 'package:ctse_app/screens/auth/login.dart';
import 'package:ctse_app/home.dart';
import 'package:ctse_app/screens/auth/userLogData.dart';
import 'package:ctse_app/services/auth.dart';

import 'package:ctse_app/services/validators.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../widgets/circleAvatar.dart';
import '../../widgets/loading.dart';

class MyProfile extends StatefulWidget {
  const MyProfile({super.key});

  @override
  State<MyProfile> createState() => _MyProfileState();
}

final updateUserForm = GlobalKey<FormState>();

class _MyProfileState extends State<MyProfile> {
  //Declaring service variables
  final AuthService _auth = AuthService();
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  UserModel currentUser = UserModel();

  //Declaring variables
  bool isLoading = false;
  late final String UserId;
  late dynamic result = 'Email';

  String? img = '';

  String dropdownvalue = 'Male';
  String? dropVal;
  String? newFirstName;
  String? newLastName;
  String? newEmail;

  // List of items in our dropdown menu
  var items = [
    'Male',
    'Female',
    'Other',
  ];

  @override
  void initState() {
    result = auth.currentUser?.uid;
    isLoading = true;

    setState(() {
      UserId = result!;
      //Set image
      if (auth.currentUser?.photoURL != null) {
        img = auth.currentUser?.photoURL;
      }
      isLoading = false;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) => isLoading
      ? const LoadingPage()
      : Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.purple.shade900,
            title: const Text('Profile'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const Main())),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.add_to_home_screen),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const UserLogData()));
                },
              ),
            ],
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

//Get Data from the firestore
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

//Function to insert an image for profile picture
  Future<void> _pickImage() async {
    setState(() {
      isLoading = true;
    });
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    final ref =
        FirebaseStorage.instance.ref('/profile').child('images/$result');
    await ref.putFile(File(image!.path));
    final uploadedPhotoUrl = await ref.getDownloadURL();
    setState(() {
      img = uploadedPhotoUrl;
      isLoading = false;
    });
  }

//
  Widget buildUserForm(UserModel user) {
    dropdownvalue = user.gender ?? 'Other';

    return Form(
        key: updateUserForm,
        autovalidateMode: AutovalidateMode.always,
        onChanged: () {
          updateUserForm.currentState!.save();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                              Container(
                                  height: 100.0,
                                  width: 100.0,
                                  child: img == ''
                                      ? const Icon(
                                          Icons.account_circle_rounded,
                                          size: 80,
                                        )
                                      : CustomCircleAvatar(
                                          myImage: NetworkImage(img!),
                                        )),
                              const SizedBox(height: 10),
                              const Text('Upload Image'),
                            ],
                          )),
                    ),
                  ),
                  TextFormField(
                    initialValue: user.firstName ?? '',
                    decoration: const InputDecoration(
                      hintText: 'Edit your First name?',
                      labelText: 'First Name *',
                    ),
                    onChanged: (value) {
                      setState(() {
                        newFirstName = value;
                      });
                    },
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
                    initialValue: user.lastName ?? '',
                    decoration: const InputDecoration(
                      hintText: 'Edit your Last name?',
                      labelText: 'Last Name *',
                    ),
                    onChanged: (value) {
                      setState(() {
                        newLastName = value;
                      });
                    },
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
                  const SizedBox(
                    height: 20,
                  ),
                  const Text('Gender *'),
                  DropdownButtonFormField(
                    value: dropdownvalue,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: items.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      print(newValue);
                      setState(() {
                        dropdownvalue = newValue!;
                        dropVal = newValue;
                      });
                    },
                  ),
                  TextFormField(
                    initialValue: user.email ?? '',
                    decoration: const InputDecoration(
                      hintText: 'Edit your Email?',
                      labelText: 'Email *',
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        newEmail = newValue!;
                      });
                    },
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
                          minimumSize: const Size.fromHeight(40),
                        ),
                        child: const Text('Update Profile'),
                        onPressed: () async {
                          setState(() {
                            isLoading = true;
                          });
                          //pass values to updateUser function to update the user data
                          dynamic result = await _auth.updateUser(newFirstName,
                              newLastName, newEmail, dropVal, img);
                          if (result == 'Success') {
                            setState(() {
                              isLoading = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: new Text("User Data Updated"),
                              backgroundColor: Colors.blue,
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
                  Container(
                      height: 50,
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          minimumSize: const Size.fromHeight(40),
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

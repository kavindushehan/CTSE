import 'package:ctse_app/screens/aboutus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../screens/auth/profile.dart';
import 'fabtabs.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  String? img = '';

  @override
  void initState() {
    setState(() {
      if (auth.currentUser?.photoURL != null) {
        img = auth.currentUser?.photoURL;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final user = auth.currentUser;

    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              SizedBox(
                  child: img == ''
                      ? const Icon(
                          Icons.account_circle_rounded,
                          size: 80,
                        )
                      : CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage(user?.photoURL ?? ''),
                        )),
              const SizedBox(height: 10),
              Text(
                user?.displayName ?? '',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ]),
          ),
          ListTile(
            leading: const Icon(Icons.home_filled),
            title: const Text("Home"),
            onTap: () => {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FabTabs(selectedIndex: 0)))
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("Profile"),
            onTap: () => {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => MyProfile()))
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text("About Us"),
            onTap: () => {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => AboutUsPage()))
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Logout"),
            onTap: () => {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FabTabs(selectedIndex: 3)))
            },
          )
        ],
      ),
    );
  }
}

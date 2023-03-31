import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:settyl_demo/screens/googlemaps_screen.dart';
import 'package:settyl_demo/screens/polygone_screen.dart';

import '../components/rounded_button.dart';
import '../constants/constants.dart';
import 'login_screen.dart';

class UserScreen extends StatefulWidget {
  static const String id = 'user_screen';

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  late User loggedInUser;
  late String fullName = '';
  late String address = '';
  bool showSpinner = false;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    final user = _auth.currentUser;
    if (user != null) {
      loggedInUser = user;
      getUserDetails();
    } else {
      Navigator.pushNamed(context, LoginScreen.id);
    }
  }

  void getUserDetails() async {
    final userSnapshot =
        await _firestore.collection('updated').doc(loggedInUser.uid).get();
    if (userSnapshot.exists) {
      final user = userSnapshot.data() as Map<String, dynamic>;
      setState(() {
        fullName = user['fullName'];
        address = user['address'];
      });
    }
  }

  Future<void> updateUserDetails() async {
    await _firestore.collection('updated').doc(loggedInUser.uid).set({
      'fullName': fullName,
      'address': address,
    }, SetOptions(merge: true));
  }

  // Future<void> addUserDetails(String userId) async {
  //   await _firestore.collection('users').doc(userId).set({
  //     // 'email': email,
  //     // 'password': password,
  //     'fullName': fullName,
  //     'address': address,
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: null,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
          title: const Text(
            'Welcome',
          ),
          bottom: const TabBar(
            tabs: [
              Tab(
                text: 'User Details',
              ),
              Tab(
                text: 'Location',
              ),
            ],
          ),
          backgroundColor: Colors.lightBlueAccent,
        ),
        body: TabBarView(
          children: [
            // StreamBuilder<DocumentSnapshot>(
            //   stream: FirebaseFirestore.instance
            //       .collection('users')
            //       .doc(user!.uid)
            //       .snapshots(),
            //   builder: (context, snapshot) {
            //     if (!snapshot.hasData) {
            //       return Center(
            //         child: CircularProgressIndicator(),
            //       );
            //     }
            //     final userData = snapshot.data!.data() as Map<String, dynamic>;
            //     return Column(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       crossAxisAlignment: CrossAxisAlignment.stretch,
            //       children: <Widget>[
            //         Text(
            //           'Full Name: ${userData['fullName']}',
            //           textAlign: TextAlign.center,
            //         ),
            //         SizedBox(
            //           height: 8.0,
            //         ),
            //         Text(
            //           'Address: ${userData['address']}',
            //           textAlign: TextAlign.center,
            //         ),
            //         SizedBox(
            //           height: 8.0,
            // ),
            //         Text(
            //           'Email: ${userData['email']}',
            //           textAlign: TextAlign.center,
            //         ),
            //         SizedBox(
            //           height: 24.0,
            //         ),
            //         RoundedButton(
            //           colour: Colors.blueAccent,
            //           title: 'Edit Details',
            //           onPressed: () {
            //             // Navigate to a screen where the user can edit their details
            //           },
            //         ),
            //       ],
            //     );
            //   },
            // ),
            Scaffold(
              backgroundColor: Colors.white,
              body: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const SizedBox(
                      height: 48.0,
                    ),
                    Text(
                      'User Details',
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 48.0,
                    ),
                    TextField(
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) {
                        fullName = value;
                      },
                      decoration: kTextFieldDecoration.copyWith(
                          hintText: 'Enter Your Full Name'),
                      controller: TextEditingController(text: fullName),
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    TextField(
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) {
                        address = value;
                      },
                      decoration: kTextFieldDecoration.copyWith(
                          hintText: 'Enter Your Address'),
                      controller: TextEditingController(text: address),
                    ),
                    const SizedBox(
                      height: 24.0,
                    ),
                    RoundedButton(
                      colour: Colors.blueAccent,
                      title: 'Save',
                      onPressed: () async {
                        setState(() {
                          showSpinner = true;
                        });
                        try {
                          // await addUserDetails(user!.uid);
                          await updateUserDetails();
                          setState(() {
                            showSpinner = false;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('User details saved'),
                            ),
                          );
                        } catch (e) {
                          print(e);
                        }
                      },
                    ),
                    const SizedBox(
                      height: 24.0,
                    ),
                    RoundedButton(
                      colour: Colors.redAccent,
                      title: 'Log Out',
                      onPressed: () {
                        _auth.signOut();
                        Navigator.pushNamed(context, LoginScreen.id);
                      },
                    ),
                  ],
                ),
              ),
            ),

            Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RoundedButton(
                      colour: Colors.lightBlueAccent,
                      title: 'Get Location',
                      onPressed: () {
                        Navigator.pushNamed(context, GoogleMapsScreen.id);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RoundedButton(
                      colour: Colors.lightBlueAccent,
                      title: 'Get Polygon',
                      onPressed: () {
                        Navigator.pushNamed(context, PolygoneScreen.id);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

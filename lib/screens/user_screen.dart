import 'package:flutter/material.dart';
import 'package:settyl_demo/screens/googlemaps_screen.dart';
import 'package:settyl_demo/screens/polygone_screen.dart';

import '../components/rounded_button.dart';

class UserScreen extends StatefulWidget {
  static const String id = 'user_screen';

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  Widget build(BuildContext context) {
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
            Center(
              child: Text('User Details'),
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

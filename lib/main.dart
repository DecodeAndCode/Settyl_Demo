import 'package:flutter/material.dart';
import 'package:settyl_demo/screens/user_screen.dart';
import 'package:settyl_demo/screens/welcome_screen.dart';
import 'package:settyl_demo/screens/login_screen.dart';
import 'package:settyl_demo/screens/registration_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const DemoApp());
}

class DemoApp extends StatelessWidget {
  const DemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        UserScreen.id: (context) => UserScreen(),
      },
    );
  }
}

import 'package:bluelantern/views/login_or_register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bluelantern/views/homepage.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context,snapshot){
          //user logged in
          if(snapshot.hasData){
            return HomePage();
          }
          // user not logged in
          else{
            return LoginOrRegister();
          }
        },
      ),
    );
  }
}
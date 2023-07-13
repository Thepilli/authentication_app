import 'package:authentication_app/screens/phone_screen.dart';
import 'package:authentication_app/services/firebase_auth_methods.dart';
import 'package:authentication_app/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  void signInWithGoogle(params) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CustomButton(
                onTap: () {
                  Navigator.pushNamed(context, PhoneScreen.routeName);
                },
                text: 'Phone Sign In'),
            CustomButton(
                onTap: () {
                  context.read<FirebaseAuthMethods>().signInWithGoogle(context);
                  // FirebaseAuthMethods(FirebaseAuth.instance).signInWithGoogle(context);
                },
                text: 'Google Sign In'),
            CustomButton(
                onTap: () {
                  context.read<FirebaseAuthMethods>().signInWithFacebook(context);
                  // FirebaseAuthMethods(FirebaseAuth.instance).signInWithFacebook(context);
                },
                text: 'Facebook Sign In'),
            CustomButton(
                onTap: () {
                  context.read<FirebaseAuthMethods>().signInAnonymous(context);
                  // FirebaseAuthMethods(FirebaseAuth.instance).signInAnonymous(context);
                },
                text: 'Anonymous Sign In'),
          ],
        ),
      ),
    );
  }
}

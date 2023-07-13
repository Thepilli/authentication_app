// ignore_for_file: prefer_const_constructors

import 'package:authentication_app/screens/responsive_login.dart';
import 'package:authentication_app/screens/widgets/gradient_button.dart';
import 'package:authentication_app/services/firebase_auth_methods.dart';
import 'package:authentication_app/utils/pallete.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResponsiveSignUpScreen extends StatefulWidget {
  static String routeName = '/responsive-signup-email-password';
  const ResponsiveSignUpScreen({Key? key}) : super(key: key);

  @override
  _ResponsiveSignUpScreenState createState() => _ResponsiveSignUpScreenState();
}

class _ResponsiveSignUpScreenState extends State<ResponsiveSignUpScreen> {
  void signInWithGoogle(params) {}
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordTextConroller = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordTextConroller.dispose();
    super.dispose();
  }

  void signUpUser() async {
//check if passwords match
    if (passwordController.text != confirmPasswordTextConroller.text) {
      //display error message
      print('Passwords do not match');
    }
    context.read<FirebaseAuthMethods>().signUpWithEmail(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
          context: context,
        );
  }

  //display error message dialog
  void displayErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Image.asset('assets/images/signin_balls.png'),
                Text(
                  'Register',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50),
                ),
                SizedBox(height: 30),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: TextFormField(
                    controller: emailController,
                    obscureText: false,
                    obscuringCharacter: '*',
                    decoration: InputDecoration(
                      hintText: 'Email',
                      contentPadding: const EdgeInsets.all(27),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Pallete.borderColor, width: 3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Pallete.gradient2, width: 3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    obscuringCharacter: '*',
                    decoration: InputDecoration(
                      hintText: 'Password',
                      contentPadding: const EdgeInsets.all(27),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Pallete.borderColor, width: 3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Pallete.gradient2, width: 3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: TextFormField(
                    controller: confirmPasswordTextConroller,
                    obscureText: true,
                    obscuringCharacter: '*',
                    decoration: InputDecoration(
                      hintText: 'Confirm Password',
                      contentPadding: const EdgeInsets.all(27),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Pallete.borderColor, width: 3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Pallete.gradient2, width: 3),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                GradientButton(buttonText: 'Sign up', onPressed: signUpUser),
                SizedBox(height: 15),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, ResponsiveLoginScreen.routeName);
                  },
                  child: Text.rich(
                    TextSpan(
                        text: 'Already have an account?  ',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Pallete.whiteColor),
                        children: const [
                          TextSpan(
                              text: 'Login',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Pallete.gradient2))
                        ]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

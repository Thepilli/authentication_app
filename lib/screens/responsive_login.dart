// ignore_for_file: prefer_const_constructors

import 'package:authentication_app/screens/responsive_signup.dart';
import 'package:authentication_app/screens/widgets/gradient_button.dart';
import 'package:authentication_app/screens/widgets/social_button.dart';
import 'package:authentication_app/services/firebase_auth_methods.dart';
import 'package:authentication_app/utils/pallete.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResponsiveLoginScreen extends StatefulWidget {
  static String routeName = '/responsive-login-email-password';
  const ResponsiveLoginScreen({Key? key}) : super(key: key);

  @override
  _ResponsiveLoginScreenState createState() => _ResponsiveLoginScreenState();
}

class _ResponsiveLoginScreenState extends State<ResponsiveLoginScreen> {
  void signInWithGoogle(params) {}
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void loginUser() {
    context.read<FirebaseAuthMethods>().loginWithEmail(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
          context: context,
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
                  'Sign In',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 50),
                ),
                SizedBox(height: 30),
                SocialButton(
                  iconPath: 'assets/svgs/g_logo.svg',
                  label: 'Continue with Google',
                  onPressed: () {
                    context.read<FirebaseAuthMethods>().signInWithGoogle(context);
                  },
                ),
                SizedBox(height: 15),
                SocialButton(
                  iconPath: 'assets/svgs/f_logo.svg',
                  label: 'Continue with Facebbok',
                  onPressed: () {
                    context.read<FirebaseAuthMethods>().signInWithFacebook(context);
                  },
                ),
                SizedBox(height: 15),
                Text('or', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                SizedBox(height: 15),
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
                SizedBox(height: 20),
                GradientButton(buttonText: 'Sign in', onPressed: loginUser),
                SizedBox(height: 15),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, ResponsiveSignUpScreen.routeName);
                  },
                  child: Text.rich(
                    TextSpan(
                        text: 'Don`t have an accout yet?  ',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Pallete.whiteColor),
                        children: const [
                          TextSpan(
                              text: 'Register',
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

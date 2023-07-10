import 'package:authentication_app/services/firebase_auth_methods.dart';
import 'package:authentication_app/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user =
        context.read<FirebaseAuthMethods>().user; //using read, instead of watch, because the value of user will not change
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (!user.isAnonymous && user.phoneNumber == null) Text(user.email!),
          if (!user.isAnonymous && user.phoneNumber == null) Text(user.providerData[0].providerId),
          if (user.phoneNumber != null) Text(user.phoneNumber!),
          Text(user.uid),
          if (!user.emailVerified && !user.isAnonymous)
            CustomButton(
              onTap: () {
                context.read<FirebaseAuthMethods>().sendEmailVerification(context);
              },
              text: 'Verify Email',
            ),
          CustomButton(
            onTap: () {
              context.read<FirebaseAuthMethods>().signOut(context);
            },
            text: 'Log out',
          ),
          CustomButton(
            onTap: () {
              context.read<FirebaseAuthMethods>().deleteAccount(context);
            },
            text: 'Delete account',
          ),
        ],
      ),
    );
  }
}

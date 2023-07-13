import 'package:authentication_app/screens/home_screen.dart';
import 'package:authentication_app/screens/responsive_login.dart';
import 'package:authentication_app/utils/show_otp_dialog.dart';
import 'package:authentication_app/utils/show_snack_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class FirebaseAuthMethods {
  final FirebaseAuth _auth;

  FirebaseAuthMethods(this._auth);

  User get user => _auth.currentUser!; // because we know the user cannot be null, we can enforce non-nullability by !

  // STATE PERSISTENCE
  Stream<User?> get authState => _auth.authStateChanges();
  // _auth.userChanges();
  // _auth.idTokenChanges();

  // EMAIL SIGN UP
  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required BuildContext context, //used for ScaffoldMessenger.of(context).showSnadckBar();
  }) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await sendEmailVerification(context);
    } on FirebaseAuthException catch (e) {
      //e is an error object
      if (e.message == 'weak-password') {
        //custom exception handling
        showSnackBar(context, 'your password is too weak');
      }
      showSnackBar(context, e.message!);
    }
  }

  //  EMAIL LOGIN
  Future<void> loginWithEmail({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      if (!_auth.currentUser!.emailVerified) {
        await sendEmailVerification(context);
      }
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
    }
  }

  // EMAIL VERIFICATION
  Future<void> sendEmailVerification(BuildContext context) async {
    try {
      _auth.currentUser!.sendEmailVerification();
      showSnackBar(context, 'Email verification sent!\nPlease check your email.');
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
    }
  }

  // GOOGLE SIGN IN
  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      if (kIsWeb) {
        GoogleAuthProvider googleProvider = GoogleAuthProvider();

        googleProvider.addScope('https://www.googleapis.com/auth/contacts.readonly');

        await _auth.signInWithPopup(googleProvider);
      } else {
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

        final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

        if (googleAuth?.accessToken != null && googleAuth?.idToken != null) {
          // Create a new credential
          final credential = GoogleAuthProvider.credential(
            accessToken: googleAuth?.accessToken,
            idToken: googleAuth?.idToken,
          );
          UserCredential userCredential = await _auth.signInWithCredential(credential);

          // if you want to do specific task like storing information in firestore
          // only for new users using google sign in (since there are no two options
          // for google sign in and google sign up, only one as of now),
          // do the following:

          // if (userCredential.user != null) {
          //   if (userCredential.additionalUserInfo!.isNewUser) {}
          // }
        }
      }
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
      print(e.message);
    }
  }

  // FACEBOOK LOGIN
  Future<void> signInWithFacebook(BuildContext context) async {
    try {
      // Trigger the sign-in flow
      final LoginResult loginResult = await FacebookAuth.instance.login();

      // Create a credential from the access token
      final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.token);

      // Once signed in, return the UserCredential
      await _auth.signInWithCredential(facebookAuthCredential);
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
    }
  }

  // PHONE SIGN IN
  /// requieres an SHA key to me added to the Firebase setting
  /// keytool -list -v -keystore "C:\Users\jirip\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android
  ///
  ///add the CFBundleURLTypes attributes below into the [my_project]/ios/Runner/Info.plist file.
  ///<!-- Put me in the [my_project]/ios/Runner/Info.plist file -->
  ///<!-- Google Sign-in Section -->
  ///<key>CFBundleURLTypes</key>
  ///<array>
  ///	<dict>
  ///		<key>CFBundleTypeRole</key>
  ///		<string>Editor</string>
  ///		<key>CFBundleURLSchemes</key>
  ///		<array>
  ///			<!-- TODO Replace this value: -->
  ///			<!-- Copied from GoogleService-Info.plist key REVERSED_CLIENT_ID -->
  ///			<string>com.googleusercontent.apps.861823949799-vc35cprkp249096uujjn0vvnmcvjppkn</string>
  ///		</array>
  ///	</dict>
  ///</array>
  ///<!-- End of the Google Sign-in Section -->

  Future<void> phoneSignIn(
    BuildContext context,
    String phoneNumber,
  ) async {
    TextEditingController codeController = TextEditingController();
    if (kIsWeb) {
      // Works only on web
      ConfirmationResult result = await _auth.signInWithPhoneNumber(phoneNumber);

      // Diplay Dialog Box To accept OTP
      showOTPDialog(
        codeController: codeController,
        context: context,
        onPressed: () async {
          PhoneAuthCredential credential = PhoneAuthProvider.credential(
            verificationId: result.verificationId,
            smsCode: codeController.text.trim(),
          );

          await _auth.signInWithCredential(credential);
          Navigator.of(context).pop(); // Remove the dialog box
        },
      );
    } else {
      // FOR ANDROID, IOS
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // only works for android
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (e) {
          // already FirebaseAuthException type, so no need to catch it on
          showSnackBar(context, e.message!);
        },
        codeSent: ((String verificationId, int? forceResendingToken) async {
          showOTPDialog(
            context: context,
            codeController: codeController,
            onPressed: () async {
              PhoneAuthCredential credential = PhoneAuthProvider.credential(
                verificationId: verificationId,
                smsCode: codeController.text.trim(),
              );
              await _auth.signInWithCredential(credential);
              Navigator.of(context).pop();
            },
          );
        }),
        codeAutoRetrievalTimeout: (String verificationId) {
          // Auto-resolution timeout
        },
      );
    }
  }

  // ANONYMOUS LOGIN
  Future<void> signInAnonymous(BuildContext context) async {
    await _auth.signInAnonymously();
    try {} on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
    }
  }

  // SIGN OUT
  Future<void> signOut(BuildContext context) async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
    }
  }

  // SIGN OUT
  Future<void> deleteAccount(BuildContext context) async {
    try {
      await _auth.currentUser!.delete();
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
    }
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>(); //watch is a substitution of Provider.of(context)
    if (firebaseUser != null) {
      return const HomeScreen();
    }
    return const ResponsiveLoginScreen();
  }
}

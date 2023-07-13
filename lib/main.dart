import 'package:authentication_app/firebase_options.dart';
import 'package:authentication_app/screens/phone_screen.dart';
import 'package:authentication_app/screens/responsive_login.dart';
import 'package:authentication_app/screens/responsive_signup.dart';
import 'package:authentication_app/services/firebase_auth_methods.dart';
import 'package:authentication_app/utils/pallete.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await FacebookAuth.i.webAndDesktopInitialize(appId: "935914017495782", cookie: true, xfbml: true, version: "v13.0");
    print('Loggin with Facebook');
  }
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FirebaseAuthMethods>(
          create: (_) => FirebaseAuthMethods(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) => context.read<FirebaseAuthMethods>().authState,
          initialData: null,
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Authentication',
        theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: Pallete.backgroundColor),
        home: const AuthWrapper(),
        routes: {
          ResponsiveSignUpScreen.routeName: (context) => const ResponsiveSignUpScreen(),
          ResponsiveLoginScreen.routeName: (context) => const ResponsiveLoginScreen(),
          PhoneScreen.routeName: (context) => const PhoneScreen(),
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'sign_up_page.dart';
import 'login_page.dart';
import 'home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rhythmo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        fontFamily: 'Daydream',
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontFamily: 'Daydream'),
          displayMedium: TextStyle(fontFamily: 'Daydream'),
          displaySmall: TextStyle(fontFamily: 'Daydream'),
          headlineMedium: TextStyle(fontFamily: 'Daydream'),
          headlineSmall: TextStyle(fontFamily: 'Daydream'),
          titleLarge: TextStyle(fontFamily: 'Daydream'),
          titleMedium: TextStyle(fontFamily: 'Daydream'),
          titleSmall: TextStyle(fontFamily: 'Daydream'),
          bodyLarge: TextStyle(fontFamily: 'Daydream'),
          bodyMedium: TextStyle(fontFamily: 'Daydream'),
          bodySmall: TextStyle(fontFamily: 'Daydream'),
          labelLarge: TextStyle(fontFamily: 'Daydream'),
          labelMedium: TextStyle(fontFamily: 'Daydream'),
          labelSmall: TextStyle(fontFamily: 'Daydream'),
        ),
      ),
      home: const AuthGate(),
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasData) {
          return const HomePage();
        }
        return const LoginPage();
      },
    );
  }
}

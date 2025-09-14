import 'sign_up_page.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';
import 'simple_user_db.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
// import 'package:flutter_line_sdk/flutter_line_sdk.dart'; // Uncomment if you set up Line SDK

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  void _handleGoogleSignIn() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Google login placeholder'),
          backgroundColor: Colors.red),
    );
  }

  void _handleFacebookSignIn() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Facebook login placeholder'),
          backgroundColor: Colors.blue),
    );
  }

  void _handleLineSignIn() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Line login placeholder'),
          backgroundColor: Colors.green),
    );
  }

  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  late SimpleUserDatabase _db;
  bool _dbLoaded = false;

  @override
  void initState() {
    super.initState();
    _db = SimpleUserDatabase();
    _db.load().then((_) {
      setState(() {
        _dbLoaded = true;
      });
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (!_dbLoaded) return;
    if (_formKey.currentState!.validate()) {
      final username = _usernameController.text;
      final password = _passwordController.text;
      if (_db.validateUser(username, password)) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid credentials.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/8bit_background3.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            width: double.infinity,
            height: double.infinity,
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/pixel_heart.png',
                            height: 40),
                        const SizedBox(width: 10),
                        Image.asset('assets/images/pixel_heart.png',
                            height: 40),
                        const SizedBox(width: 10),
                        Image.asset('assets/images/pixel_heart.png',
                            height: 40),
                        const SizedBox(width: 10),
                        Image.asset('assets/images/pixel_heart.png',
                            height: 40),
                        const SizedBox(width: 10),
                        Image.asset('assets/images/pixel_heart.png',
                            height: 40),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.5),
                            Colors.black.withOpacity(0.3),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 20),
                      child: const Text(
                        'Welcome Back to Rhythmo 🎧',
                        style: TextStyle(
                          fontFamily: 'Daydream',
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 240, 32, 153),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 32),
                    TextFormField(
                      controller: _usernameController,
                      style: const TextStyle(
                        fontFamily: 'Daydream',
                        color: Colors.white,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Username',
                        labelStyle: TextStyle(
                          fontFamily: 'Daydream',
                          color: Colors.white,
                        ),
                        filled: true,
                        fillColor: Color.fromARGB(
                          122,
                          255,
                          255,
                          255,
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        prefixIcon: Icon(Icons.person, color: Colors.white),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your username';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      style: const TextStyle(
                        fontFamily: 'Daydream',
                        color: Colors.white,
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(
                          fontFamily: 'Daydream',
                          color: Colors.white,
                        ),
                        filled: true,
                        fillColor: Color(0x80FFFFFF),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        prefixIcon: Icon(Icons.lock, color: Colors.white),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 38),
                    ElevatedButton(
                      onPressed: _handleLogin,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                      ),
                      child: const Text(
                        '>>> Login',
                        style: TextStyle(fontFamily: 'Daydream', fontSize: 20),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUpPage()),
                        );
                      },
                      child: const Text(
                        'Go back to Sign Up',
                        style: TextStyle(
                          fontFamily: 'Daydream',
                          fontSize: 16,
                          color: Color.fromARGB(255, 240, 32, 153),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.g_mobiledata,
                                color: Colors.black, size: 24),
                            label: const Text(
                              'Google',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: _handleGoogleSignIn,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.facebook,
                                color: Colors.white, size: 24),
                            label: const Text(
                              'Facebook',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: _handleFacebookSignIn,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1877F3),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.chat,
                                color: Colors.white, size: 24),
                            label: const Text(
                              'Line',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: _handleLineSignIn,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF06C755),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

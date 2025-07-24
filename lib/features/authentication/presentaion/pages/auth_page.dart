import 'package:flutter/material.dart';
import 'package:instagram/features/authentication/presentaion/pages/login.dart';
import 'package:instagram/features/authentication/presentaion/pages/registerPage.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool showLoginPage = true;

  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: showLoginPage
            ? LoginPage(togglePages: togglePages)
            : RegisterPage(togglePages: togglePages),
      ),
    );
  }
}

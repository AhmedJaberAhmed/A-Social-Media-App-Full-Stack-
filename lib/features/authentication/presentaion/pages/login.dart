import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:instagram/features/authentication/presentaion/cubits/auth_cubit/auth_cubit.dart';
 import '../components/my_buttun.dart';
import '../components/my_textField.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback togglePages;

  const LoginPage({super.key, required this.togglePages});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final PassController = TextEditingController();

  void login() {
    final String email = emailController.text;
    final String password = PassController.text;
    final authCubit = context.read<AuthCubit>();

    if (email.isNotEmpty && password.isNotEmpty) {
      authCubit.loginWithEmailAndPw(email, password);
    } else {
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(
          message: "Please enter both email and password",
        ),
      );
    }
  }

  @override
  void dispose() {
    PassController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lock_open_rounded, size: 80, color: Theme.of(context).primaryColor),
                SizedBox(height: 50),
                Text(
                  "Welcome Back, You Have Been Missed!",
                  style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 16),
                ),
                SizedBox(height: 25),
                MyTextField(controller: emailController, hintText: "Email", obscureText: false),
                SizedBox(height: 12),
                MyTextField(controller: PassController, hintText: "Password", obscureText: true),
                SizedBox(height: 25),
                MyButton(onTap: login, text: "Login"),
                SizedBox(height: 25),
                RichText(
                  text: TextSpan(
                    text: "Not a member? ",
                    style: TextStyle(color: Colors.grey[700]),
                    children: [
                      TextSpan(
                        text: "Register now",
                        style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            widget.togglePages();
                          },
                      ),
                    ],
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

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:instagram/features/authentication/presentaion/cubits/auth_cubit/auth_cubit.dart';
 import '../../../../responsive/canstariant_scaffold.dart';
import '../components/my_buttun.dart';
import '../components/my_textField.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback togglePages;

  const RegisterPage({super.key, required this.togglePages});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final PassController = TextEditingController();
  final confirmPassController = TextEditingController();

  void register() {
    final String name = nameController.text.trim();
    final String email = emailController.text.trim();
    final String pw = PassController.text.trim();
    final String confirmPw = confirmPassController.text.trim();


    final authCubit = context.read<AuthCubit>();

    if (email.isNotEmpty && name.isNotEmpty && pw.isNotEmpty && confirmPw.isNotEmpty) {
      if (pw == confirmPw) {
        authCubit.register(name, email, pw);

        final overlay = Overlay.of(context);
        showTopSnackBar(
          overlay,
          CustomSnackBar.success(message: "Register Success"),
        );
            } else {
        final overlay = Overlay.of(context);
        showTopSnackBar(
          overlay,
          CustomSnackBar.error(message: "Password does not match"),
        );
            }
    } else {
      final overlay = Overlay.of(context);

      showTopSnackBar(
        overlay,
        CustomSnackBar.error(message: "Please complete all fields"),
      );
        }
  }

  @override
  void dispose() {
    nameController.dispose();
    PassController.dispose();
    confirmPassController.dispose();
    emailController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return ConstrainedScaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Icon(Icons.lock_open_rounded, size: 80, color: Theme.of(context).primaryColor),
                const SizedBox(height: 50),
                Text(
                  "Create an account",
                  style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 16),
                ),
                const SizedBox(height: 25),
                MyTextField(controller: nameController, hintText: "Name", obscureText: false),
                const SizedBox(height: 25),
                MyTextField(controller: emailController, hintText: "Email", obscureText: false),
                const SizedBox(height: 25),
                MyTextField(controller: PassController, hintText: "Password", obscureText: true),
                const SizedBox(height: 25),
                MyTextField(controller: confirmPassController, hintText: "Confirm Password", obscureText: true),
                const SizedBox(height: 25),
                MyButton(onTap: register, text: "Register"),
                const SizedBox(height: 25),
                RichText(
                  text: TextSpan(
                    text: "Already a member? ",
                    style: TextStyle(color: Colors.grey[700]),
                    children: [
                      TextSpan(
                        text: "Login now",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer: TapGestureRecognizer()..onTap = widget.togglePages,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

}

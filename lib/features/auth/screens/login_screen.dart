import 'package:flutter/material.dart';
import 'package:pericare/features/auth/screens/widgets/custom_form_field.dart';
import 'package:pericare/features/auth/screens/widgets/custom_text_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Login',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              CustomFormField(
                hintText: 'Email',
                onChanged: (val) {},
              ),
              const SizedBox(height: 20),
              CustomFormField(
                hintText: 'Password',
                onChanged: (val) {},
                obscureText: true,
              ),
              const SizedBox(height: 40),
              CustomTextButton(
                text: 'Log In',
                onPressed: () {},
              ),
              const SizedBox(height: 20),
              const Text(
                'Or',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 20),
              CustomTextButton(
                text: 'Continue with Google',
                onPressed: () {},
                isSocial: true,
              ),
              const SizedBox(height: 10),
              CustomTextButton(
                text: 'Continue with Apple',
                onPressed: () {},
                isSocial: true,
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?"),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Sign Up'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

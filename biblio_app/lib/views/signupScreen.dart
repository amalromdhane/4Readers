import 'package:flutter/material.dart';
import 'package:biblio_app/widgets/button.dart';
import 'package:biblio_app/widgets/text_field.dart';
import 'package:biblio_app/views/LoginScreen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
  }

  Future<void> register(BuildContext context) async {
    final username = nameController.text;
    final email = emailController.text;
    final password = passwordController.text;

    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      _showMessage(context, 'Error', 'Fields cannot be empty');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/api/users/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 201) {
        _showMessage(context, 'Success', 'User registered successfully');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      } else if (response.statusCode == 400) {
        _showMessage(context, 'Error', 'Username or email already taken');
      } else {
        _showMessage(context, 'Error', 'Failed to register');
      }
    } catch (e) {
      _showMessage(context, 'Error', 'Network error: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showMessage(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 231, 216, 176),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SizedBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height:250,
                width: 800,
                child: Image.asset('assets/images/bg3.png'),
              ),
              TextFieldInput(
                icon: Icons.person,
                textEditingController: nameController,
                hintText: 'Enter your name',
                textInputType: TextInputType.text,
              ),
              TextFieldInput(
                icon: Icons.email,
                textEditingController: emailController,
                hintText: 'Enter your email',
                textInputType: TextInputType.emailAddress,
              ),
              TextFieldInput(
                icon: Icons.lock,
                textEditingController: passwordController,
                hintText: 'Enter your password',
                textInputType: TextInputType.text,
                isPass: true,
              ),
              MyButtons(
                onTap: () => register(context),
                text: isLoading ? "Signing Up..." : "Sign Up",
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account?"),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      " Login",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}






















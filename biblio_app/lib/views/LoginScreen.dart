import 'dart:convert';
import 'package:biblio_app/views/signupScreen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:biblio_app/views/HomeScreen.dart';
import 'package:biblio_app/views/AdminDashboard.dart'; 
import 'package:shared_preferences/shared_preferences.dart';
import 'package:biblio_app/widgets/button.dart';
import 'package:biblio_app/widgets/text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void loginUser() {
    authenticate(context);
  }
Future<void> authenticate(BuildContext context) async {
  final email = emailController.text;
  final password = passwordController.text;

  if (email.isEmpty || password.isEmpty) {
    _showMessage(context, 'Error', 'Fields cannot be empty');
    return;
  }

  try {
    final response = await http.post(
      Uri.parse('http://localhost:3000/api/users/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();
      final responseBody = jsonDecode(response.body);
      print('Response body: $responseBody');  // Vérifiez la réponse du backend

      // Enregistrer le token et le rôle
      prefs.setString('token', responseBody['token']);
      prefs.setString('role', responseBody['role']);
      print('Role stored: ${prefs.getString('role')}');  // Vérifiez que le rôle est stocké

      // Redirection en fonction du rôle
      if (responseBody['role'] == 'admin') {
        print('Redirecting to AdminDashboard');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminDashboard()),
        );
      } else if (responseBody['role'] == 'user') {
        print('Redirecting to HomePage');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        print('Unknown role');
        _showMessage(context, 'Error', 'Unknown role');
      }
    } else {
      _showMessage(context, 'Error', 'Invalid credentials');
    }
  } catch (e) {
    _showMessage(context, 'Error', 'Network error: $e');
  }
}


  void _showMessage(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 231, 216, 176),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: double.infinity,
                height: height / 2.7,
                child: Image.asset('assets/images/bg3.png'),
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
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 35),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color.fromARGB(255, 206, 153, 7),
                    ),
                  ),
                ),
              ),
              MyButtons(onTap: loginUser, text: "Log In"),
              SizedBox(height: height / 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const SignupScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      "SignUp",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

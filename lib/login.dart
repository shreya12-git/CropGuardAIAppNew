import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:http/http.dart' as http;
import 'homepage.dart';
import 'main.dart'; // Ensure this file contains MyHomePage
import 'signup.dart';

Future<bool> login(String email, String password, BuildContext context) async {
  Uri url = Uri.parse('http://localhost:8000/api/signin');

  try {
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login Successful!!")),
      );

      // Navigate to HomePage after successful login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainHomePage(title: 'Home Page')),
      );

      return true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid Credentials!")),
      );
      return false;
    }
  } catch (error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error: $error")),
    );
    return false;
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title});
  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFCAE0AB),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipPath(
              clipper: OvalBottomBorderClipper(),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.4,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/login2.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                'Log in',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF273E05),
                ),
              ),
            ),
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                      child: TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color.fromARGB(147, 54, 87, 9),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Color(0xFF375709)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          labelText: "Email/UserName",
                          labelStyle: const TextStyle(color: Color.fromARGB(255, 223, 218, 218)),
                          floatingLabelStyle: const TextStyle(color: Colors.black),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Your Email';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                      child: TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color.fromARGB(147, 54, 87, 9),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Color(0xFF375709)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          labelText: "Password",
                          labelStyle: const TextStyle(color: Color.fromARGB(255, 223, 218, 218)),
                          floatingLabelStyle: const TextStyle(color: Colors.black),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please Enter Your Password';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: GestureDetector(
                        onTap: () {
                          // Forgot password functionality here
                        },
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: const Text(
                            "Forgot Password?",
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 9),
                      child: Center(
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              await login(emailController.text, passwordController.text, context);
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Color.fromARGB(219, 221, 166, 85)),
                            fixedSize: MaterialStateProperty.all(const Size(150, 50)),
                          ),
                          child: const Text('Login', style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const SignUpPage(title: 'SignUpPage',)),
                          );
                        },
                        child: Align(
                          alignment: Alignment.center,
                          child: const Text(
                            "Don’t have an account? Sign Up",
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

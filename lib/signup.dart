import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'codepage.dart';
import 'package:http/http.dart' as http;

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key, required this.title});
  final String title;

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  Future<void> signUpUser(String email, String password,String confirmPassword) async {
    Uri url = Uri.parse('http://localhost:8000/api/sendotp'); // Fixed extra space issue

  final Map<String, String> requestBody = {
    "email": email,
    "password": password,
    "confirmPassword": confirmPassword // Add this if your backend requires it
  };


  print("Request Body: ${jsonEncode(requestBody)}"); // Debugging line

  try {
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(requestBody),
    );

    print("Response: ${response.body}"); // Debugging line

    if (!mounted) return;

    final Map<String, dynamic> responseBody = jsonDecode(response.body);
    
    if (response.statusCode == 200 && responseBody['success'] == true) {
      print("Signup successful");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Signup Successful!'),
        backgroundColor: Color.fromARGB(255, 127, 168, 70), ),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CodePage(email: email, title: 'OTP Page',password: password,),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Signup failed: ${responseBody["message"]}'),
        backgroundColor: Color.fromARGB(255, 127, 168, 70), ),
      );
    }
  } catch (e) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: ${e.toString()}'),
      backgroundColor: Color.fromARGB(255, 127, 168, 70), ),
    );
  }
}

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
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text(
                'Create your account',
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
                    buildTextField(
                      controller: emailController,
                      label: "Email/UserName",
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Please Enter Your Email';
                        return null;
                      },
                    ),
                    buildTextField(
                      controller: passwordController,
                      label: "Password",
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Please Enter Your Password';
                        return null;
                      },
                    ),
                    buildTextField(
                      controller: confirmPasswordController,
                      label: "Confirm Password",
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Please Enter Your Password';
                        if (value != passwordController.text) return 'Passwords do not match';
                        return null;
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 9),
                      child: Center(
                        child: ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              signUpUser(emailController.text, passwordController.text, confirmPasswordController.text);
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Color.fromARGB(219, 221, 166, 85)),
                            fixedSize: MaterialStateProperty.all(const Size(150, 50)),
                          ),
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(color: Colors.white),
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

  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
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
          labelText: label,
          labelStyle: const TextStyle(color: Color.fromARGB(255, 223, 218, 218)),
          floatingLabelStyle: const TextStyle(color: Colors.black),
        ),
        validator: validator,
      ),
    );
  }
}
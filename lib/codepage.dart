import 'dart:convert';
import 'package:cropguardaiapp2/homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:http/http.dart' as http;

/// API CALL: Verify OTP
Future<bool> verifyOTP(String email, String otp, String password) async {
  Uri url = Uri.parse('http://localhost:8000/api/createuser'); // Replace with actual API

  try {
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "otp": otp, "password": password}),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return data['success']; // Expecting backend response like { "success": true/false }
    }
  } catch (e) {
    print("Error verifying OTP: $e");
  }
  return false;
}

class CodePage extends StatefulWidget {
  final String email;
  final String password; // New: Get password from signup
  final String title;

  const CodePage({
    Key? key,
    required this.email,
    required this.password, // Accept password
    required this.title,
  }) : super(key: key);

  @override
  State<CodePage> createState() => _CodePageState();
}

class _CodePageState extends State<CodePage> {
  String? verificationCode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFCAE0AB),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 50),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  'assets/code.jpg',
                  height: 200,
                  width: 200,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Verify Code',
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF273E05),
                ),
              ),
              const Text("A confirmation code has been sent to your email."),
              const SizedBox(height: 20),
              OtpTextField(
                numberOfFields: 6,
                borderColor: const Color(0xFF273E05),
                showFieldAsBox: true,
                focusedBorderColor: const Color(0xFF273E05),
                onCodeChanged: (String code) {
                  // Handle real-time changes if needed
                },
                onSubmit: (String code) async {
                  setState(() {
                    verificationCode = code;
                  });

                  bool isVerified = await verifyOTP(widget.email, code, widget.password);

                  if (isVerified) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('OTP Verified Successfully!'),
                      backgroundColor: Color.fromARGB(255, 127, 168, 70), ),
                    );

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MainHomePage(title: 'Main Home Page'),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Invalid OTP. Please try again.'),
                      backgroundColor: Color.fromARGB(255, 127, 168, 70), ),
                    );
                  }
                },
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  // Implement OTP Resend Logic
                },
                child: const Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "Resend Code",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
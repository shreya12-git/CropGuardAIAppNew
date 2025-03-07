import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class ChatBotPage extends StatefulWidget {
  const ChatBotPage({super.key, required this.title});
  final String title;

  @override
  State<ChatBotPage> createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  static const apiKey = 'AIzaSyCY7jvt1sjs6d_ONE9fkIx93iB-kDsPxbQ'; // Replace with your API key.
  final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);

  final TextEditingController _userPrompt = TextEditingController(); // Controller for user input.
  final List<Message> _messages = []; // List to store user and bot messages.

  // Function to handle user input and AI response
  Future<void> sendPrompt() async {
    final message = _userPrompt.text; // Retrieve user input.
    if (message.trim().isEmpty) return; // Ignore empty inputs.

    _userPrompt.clear(); // Clear the input field.

    // Add the user's message to the chat
    setState(() {
      _messages.add(Message(sender: 'You', message: message));
    });

    try {
      // Send user input as prompt to the AI model
      final prompt = [Content.text(message)];
      final response = await model.generateContent(prompt);

      // Add the AI's response to the chat
      setState(() {
        _messages.add(Message(sender: 'Bot', message: response.text ?? 'No response received.'));
      });
    } catch (e) {
      setState(() {
        _messages.add(Message(sender: 'Bot', message: 'Error: $e'));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF88C431),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundImage: const AssetImage('assets/logo.png'),
          ),
        ),
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Chat message list
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final isUser = message.sender == 'You';
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isUser ? Color(0xFF88C431) : const Color.fromARGB(255, 237, 227, 227),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      message.message,
                      style: TextStyle(color: isUser ? Colors.white : Colors.black),
                    ),
                  ),
                );
              },
            ),
          ),
          // User input field and send button
          Padding(
            padding: const EdgeInsets.all(8.0), // Padding around the row
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, bottom: 8.0), // Left and bottom spacing for input
                    child: TextField(
                      controller: _userPrompt,
                      decoration: const InputDecoration(
                        hintText: 'Type your message...',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Color.fromARGB(255, 245, 242, 242)),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0), // Bottom spacing for send button
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Color(0xFF88C431)),
                    onPressed: sendPrompt, // Call sendPrompt on button press
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Message class to store chat data
class Message {
  final String sender; // Sender of the message (e.g., 'You' or 'Bot')
  final String message; // Message text

  Message({required this.sender, required this.message});
}

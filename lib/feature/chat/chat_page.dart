import 'package:flutter/material.dart';
import 'package:task_app/core/constants/app_colors.dart';

class ChatPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.primary,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Project Study Case Chat',
              style: TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16.0),
              children: [
                _buildMessage(
                  isMe: false,
                  username: 'Sara',
                  color: Colors.blue,
                  imageUrl: 'assets/images/avatar/avatar-5.png',
                  message: 'Hey team, let\'s discuss the study case for the project.',
                ),
                _buildMessage(
                  isMe: true,
                  username: 'Omer',
                  color: Colors.green,
                  imageUrl: 'assets/images/avatar/avatar-3.png',
                  message: 'Sure! I suggest we start with defining the project scope.',
                ),
                _buildMessage(
                  isMe: false,
                  username: 'Adam',
                  color: Colors.orange,
                  imageUrl: 'assets/images/avatar/avatar-4.png',
                  message: 'That sounds good. We should also outline the objectives clearly.',
                ),
                _buildMessage(
                  isMe: true,
                  username: 'Omer',
                  color: Colors.green,
                  imageUrl: 'assets/images/avatar/avatar-3.png',
                  message: 'Agreed. We can then proceed to gather requirements and constraints.',
                ),
                _buildMessage(
                  isMe: false,
                  username: 'Sara',
                  color: Colors.blue,
                  imageUrl: 'assets/images/avatar/avatar-5.png',
                  message: 'Let\'s also discuss potential risks and mitigation strategies.',
                ),
                _buildMessage(
                  isMe: true,
                  username: 'Omer',
                  color: Colors.green,
                  imageUrl: 'assets/images/avatar/avatar-3.png',
                  message: 'Absolutely. Risk assessment is crucial for a successful study case.',
                ),
                _buildMessage(
                  isMe: false,
                  username: 'Adam',
                  color: Colors.orange,
                  imageUrl: 'assets/images/avatar/avatar-4.png',
                  message: 'I\'ll draft an initial outline and share it with the team by tomorrow.',
                ),
                _buildMessage(
                  isMe: true,
                  username: 'Omer',
                  color: Colors.green,
                  imageUrl: 'assets/images/avatar/avatar-3.png',
                  message: 'Great! Looking forward to it.',
                ),
              ],
            ),
          ),
          _buildInputField(),
        ],
      ),
    );
  }

  Widget _buildMessage({
    required bool isMe,
    required String username,
    required Color color,
    required String imageUrl,
    required String message,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMe)
            CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage(imageUrl),
            ),
          SizedBox(width: 8.0),
          Expanded(
            child: Column(
              crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Text(
                  username,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isMe ? Colors.blue : Colors.green, // Set username color based on isMe
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 4.0),
                  padding: EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: isMe ? const Color.fromARGB(255, 130, 231, 93) : const Color.fromARGB(255, 158, 158, 158).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Text(
                    message,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (isMe)
            CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage(imageUrl),
            ),
        ],
      ),
    );
  }

  Widget _buildInputField() {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Send Message',
          suffixIcon: const Icon(
            Icons.send,
            color: AppColors.primary,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(
              color: AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChatPage(),
    );
  }
}

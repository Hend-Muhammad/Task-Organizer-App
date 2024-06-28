import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_app/core/constants/app_colors.dart';

class ChatPage extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

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
              'Todo App Project Chat',
              style: TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('chat').orderBy('timestamp').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                var messages = snapshot.data!.docs;
                List<Widget> messageWidgets = messages.map((message) {
                  var data = message.data() as Map<String, dynamic>;
                  return _buildMessage(
                    isMe: data['uid'] == FirebaseAuth.instance.currentUser!.uid,
                    username: data['username'],
                    color: Color(data['color']), // Convert int to Color
                    imageUrl: data['imageUrl'],
                    message: data['message'],
                  );
                }).toList();

                return ListView(
                  padding: EdgeInsets.all(16.0),
                  children: messageWidgets,
                );
              },
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
                    color: color, // Use the color value from Firestore
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
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Send Message',
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
          ),
          IconButton(
            icon: const Icon(Icons.send, color: AppColors.primary),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }

  void _sendMessage() async {
    if (_controller.text.isEmpty) return;

    var user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('chat').add({
        'uid': user.uid,
        'username': user.displayName ?? 'Anonymous',
        'message': _controller.text,
        'timestamp': Timestamp.now(),
        'color': Colors.green.value, // Store color as int
        'imageUrl': 'assets/images/avatar/avatar-3.png', // update this based on your app's logic
      });

      _controller.clear();
    }
  }
}

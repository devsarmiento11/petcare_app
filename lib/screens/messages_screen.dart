import 'package:flutter/material.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F4F4),

      appBar: AppBar(
        backgroundColor: const Color(0xff4E7A80),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: const Text(
          "Messages",
          style: TextStyle(color: Colors.black),
        ),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [

            Icon(
              Icons.chat_bubble_outline,
              size: 90,
              color: Colors.black,
            ),

            SizedBox(height: 20),

            Text(
              "No messages",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),

          ],
        ),
      ),
    );
  }
}

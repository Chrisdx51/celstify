import 'dart:io';
import 'package:flutter/material.dart';

class CommentsPage extends StatelessWidget {
  final String username;
  final String postText;
  final String? postImage;

  const CommentsPage({
    Key? key,
    required this.username,
    required this.postText,
    this.postImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(
              username,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(postText),
          ),
          if (postImage != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.file(
                File(postImage!),
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          const Divider(),
          Expanded(
            child: ListView(
              children: const [
                ListTile(
                  title: Text('User1'),
                  subtitle: Text('This is a comment!'),
                ),
                ListTile(
                  title: Text('User2'),
                  subtitle: Text('Another comment!'),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Write a comment...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    // Handle sending comment
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

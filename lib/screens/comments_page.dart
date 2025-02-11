import 'package:flutter/material.dart';

class CommentsPage extends StatelessWidget {
  final String username;
  final String postText;

  const CommentsPage({
    Key? key,
    required this.username,
    required this.postText,
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
          const Divider(),
          Expanded(
            child: ListView(
              children: const [
                // Placeholder comments
                ListTile(
                  title: Text('User1'),
                  subtitle: Text('This is a comment!'),
                ),
                ListTile(
                  title: Text('User2'),
                  subtitle: Text('Another comment here!'),
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
                    // Handle sending the comment
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
